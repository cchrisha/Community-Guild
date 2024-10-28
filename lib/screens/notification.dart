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

      if (token == null || userId == null) {
        throw Exception('Token or User ID is null. User not logged in.');
      }

      // Fetch main notifications
      final mainResponse = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (mainResponse.statusCode == 200) {
        List<dynamic> mainNotifications = json.decode(mainResponse.body);

        // Fetch transaction notifications
        final transactionResponse = await http.get(
          Uri.parse('https://api-tau-plum.vercel.app/transaction-notifications/$userId'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        List<dynamic> transactionNotifications = [];
        if (transactionResponse.statusCode == 200) {
          transactionNotifications = json.decode(transactionResponse.body);
        } else {
          print('Failed to load transaction notifications. Status code: ${transactionResponse.statusCode}');
        }

        // Fetch verification notifications
        final verificationResponse = await http.get(
          Uri.parse('https://api-tau-plum.vercel.app/api/user/notifications'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        List<dynamic> verificationNotifications = [];
        if (verificationResponse.statusCode == 200) {
          verificationNotifications = json.decode(verificationResponse.body);
        } else {
          print('Failed to load verification notifications. Status code: ${verificationResponse.statusCode}');
        }

        // Merge and sort notifications
        List<dynamic> combinedNotifications = [
          ...mainNotifications,
          ...transactionNotifications,
          ...verificationNotifications
        ];
        
        combinedNotifications.sort((a, b) => DateTime.parse(b['createdAt']).compareTo(DateTime.parse(a['createdAt'])));

        setState(() {
          _notifications = combinedNotifications;
        });
      } else {
        print('Failed to load main notifications. Status code: ${mainResponse.statusCode}');
      }
    } catch (e) {
      print('Error in fetchNotifications: $e');
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

      final jobreqresponse = await http.put(
        Uri.parse('$apiUrl/$notificationId/read'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (jobreqresponse.statusCode == 200) {
        setState(() {
          _notifications = _notifications.map((notification) {
            if (notification['_id'] == notificationId) {
              notification['isRead'] = true;
            }
            return notification;
          }).toList();
        });
      } else {
        print('Failed to mark notification as read. Status code: ${jobreqresponse.statusCode}');
      }

      final response = await http.patch(
        Uri.parse('https://api-tau-plum.vercel.app/transaction-notifications/$notificationId/read'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _notifications = _notifications.map((notification) {
            if (notification['_id'] == notificationId) {
              notification['isRead'] = true;
            }
            return notification;
          }).toList();
        });
      } else {
        print('Failed to mark notification as read. Status code: ${response.statusCode}');
      }

      final verificationResponse = await http.put(
      Uri.parse('https://api-tau-plum.vercel.app/api/user/notifications/$notificationId/read'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (verificationResponse.statusCode == 200) {
      setState(() {
        _notifications = _notifications.map((notification) {
          if (notification['_id'] == notificationId) {
            notification['isRead'] = true;
          }
          return notification;
        }).toList();
      });
    } else {
      print('Failed to mark notification as read. Status code: ${verificationResponse.statusCode}');
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
            Navigator.pop(context, MaterialPageRoute(builder: (context) => const HomePage()));
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
                    color: isRead ? Colors.white : Colors.lightBlue.shade100,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        notificationMessage,
                        style: TextStyle(
                          fontSize: 16,
                          color: isRead ? Colors.black : Colors.blue,
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