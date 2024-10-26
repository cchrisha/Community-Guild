import 'package:community_guild/screens/admin/admin_userDetails.dart';
import 'package:community_guild/screens/home.dart';
import 'package:community_guild/widget/loading_widget/ink_drop.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';


class AdminNotificationsScreen extends StatefulWidget {
  const AdminNotificationsScreen({Key? key}) : super(key: key);

  @override
  _AdminNotificationsScreenState createState() => _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  final String apiUrl = 'https://api-tau-plum.vercel.app/api/verification/notifications';
  List<dynamic> _notifications = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
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
      print('Fetching notifications...');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      print('Token: $token');
      if (token == null) {
        throw Exception('Token is null. User not logged in.');
      }
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        print('Parsed Data: $data');
        setState(() {
          _notifications = data; // Store the entire notification object
        });
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    print("Attempting to mark notification as read: $notificationId");
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
        setState(() {
          // Update the notification list locally
          _notifications = _notifications.map((notification) {
            if (notification['_id'] == notificationId) {
              notification['isRead'] = true; // Mark it as read
            }
            return notification;
          }).toList();
        });
      } else {
        print('Failed to mark notification as read. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Notifications',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
      ),
      body: _notifications.isEmpty
          ? Center(
              child: InkDrop(
                size: 40,
                color: Colors.lightBlue,
                ringColor: Colors.lightBlue.withOpacity(0.2),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                var notification = _notifications[index];
                String notificationMessage = notification['message'];
                bool isRead = notification['isRead'] ?? false;

                return GestureDetector(
                  onTap: () {
                    if (!isRead) {
                      markNotificationAsRead(notification['_id']);
                    }
                  },
                  child: Card(
                    elevation: 3,
                    color: isRead ? Colors.white : Colors.lightBlue.shade100, // Highlight unread in blue
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        notificationMessage,
                        style: TextStyle(
                          fontSize: 16,
                          color: isRead ? Colors.black : Colors.blue, // Text color for unread notifications
                          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
