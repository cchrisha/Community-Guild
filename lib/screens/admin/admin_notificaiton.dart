import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminNotificationsScreen extends StatefulWidget {
  const AdminNotificationsScreen({Key? key}) : super(key: key);

  @override
  _AdminNotificationsScreenState createState() => _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  final String apiUrl = 'https://api-tau-plum.vercel.app/api/notifications/admin';
  Timer? _timer;
  bool _isShowingNotification = false; // Flag to track if a notification is being shown
  int _unreadNotificationCount = 0;
  List<dynamic> _notifications = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications(); // Fetch notifications on screen load
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchNotifications();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        print('Token is null. User not logged in.');
        return;
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _notifications = data;
          _unreadNotificationCount = data.where((notification) => !notification['isRead']).length;
        });

        // Sort notifications by date to get the latest one
        data.sort((a, b) => DateTime.parse(b['createdAt']).compareTo(DateTime.parse(a['createdAt'])));

        if (data.isNotEmpty) {
          var latestNotification = data.first;
          if (!latestNotification['isRead']) {
            // Show the latest unread notification in the overlay
            _showTopNotification(latestNotification['message']);

            // Mark the notification as read after showing it
            await markNotificationAsRead(latestNotification['_id']);
          }
        }
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        print('Token is null. User not logged in.');
        return;
      }

      final response = await http.put(
        Uri.parse('$apiUrl/$notificationId/read'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Notification marked as read.');
      } else {
        print('Failed to mark notification as read. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  void _showTopNotification(String message) {
    if (_isShowingNotification) return; // Prevent multiple overlays

    _isShowingNotification = true;

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05,
        child: Material(
          elevation: 10.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
      _isShowingNotification = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Notifications'),
      ),
      body: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return ListTile(
            title: Text(notification['message']),
            subtitle: Text(notification['createdAt']),
            tileColor: notification['isRead'] ? Colors.transparent : Colors.grey.shade300,
          );
        },
      ),
    );
  }
}
