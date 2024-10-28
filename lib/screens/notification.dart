import 'package:community_guild/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/loading_widget/ink_drop.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final String apiUrl = 'https://api-tau-plum.vercel.app/api/notifications';
  List<dynamic> _notifications = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Fetch notifications periodically every 5 seconds
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
    final userId = prefs.getString('user_id');

    print('Token: $token');
    print('User ID: $userId');

    if (token == null || userId == null) {
      throw Exception('Token or User ID is null. User not logged in.');
    }

    // Fetch main notifications
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Main Notifications Response Status: ${response.statusCode}');
    if (response.statusCode == 200) {
      List<dynamic> notificationsData = json.decode(response.body);
      print('Parsed Main Notifications Data: $notificationsData');

      // Fetch transaction notifications
      final transactionResponse = await http.get(
        Uri.parse('https://api-tau-plum.vercel.app/transaction-notifications/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Transaction Notifications Response Status: ${transactionResponse.statusCode}');
      if (transactionResponse.statusCode == 200) {
        List<dynamic> transactionNotifications = json.decode(transactionResponse.body);
        print('Parsed Transaction Notifications: $transactionNotifications');

        // Merge both notification lists
        List<dynamic> combinedNotifications = [...transactionNotifications, ...notificationsData];
        
        // Sort notifications by date to get the latest one
        combinedNotifications.sort((a, b) => DateTime.parse(b['createdAt']).compareTo(DateTime.parse(a['createdAt'])));

        setState(() {
          _notifications = combinedNotifications;
          print('_notifications after combining: $_notifications');
        });
      } else {
        print('Failed to load transaction notifications. Status code: ${transactionResponse.statusCode}');
      }
    } else {
      print('Failed to load main notifications. Status code: ${response.statusCode}');
    }
    } catch (e) {
      print('Error in fetchNotifications: $e');
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

    // Use PATCH method for marking notification as read
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
          'Notifications',
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
