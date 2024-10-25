import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'admin_notificaiton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboard extends StatefulWidget {
  final int totalUsers;
  final int completedTransactions;

  const AdminDashboard({
    super.key,
    required this.totalUsers,
    required this.completedTransactions,
  });

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final String apiUrl = 'https://api-tau-plum.vercel.app/api/verification/notifications';
  Timer? _timer;
  bool _isShowingNotification = false; // Flag to track if a notification is being shown
  int _unreadNotificationCount = 0;

  @override
  void initState() {
    super.initState();
    fetchNotifications(); // Fetch notifications on dashboard load
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchNotifications();
    });
  }

  Future<void> fetchNotifications() async {
    try {
      print('Fetching notifications...');
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

      print('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // Count unread notifications
        int unreadCount = data.where((notification) => !notification['isRead']).length;
        setState(() {
          _unreadNotificationCount = unreadCount;
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
    print("Attempting to mark notification as read:");
    print("Notification ID: $notificationId");
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      print("Auth Token: $token");

      if (token == null) {
        print('Token is null. User not logged in.');
        return;
      }

      final response = await http.put(
        Uri.parse('https://api-tau-plum.vercel.app/api/verification/notifications/$notificationId/read'), // Use actual notificationId here
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Notification marked as read.');
      } else {
        print('Failed to mark notification as read. Status code: ${response.statusCode}');
        print("Response body: ${response.body}");
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

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
      _isShowingNotification = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when disposing the widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.blue,
            ),
            onPressed: () {
              Navigator.push(
                context,
                  MaterialPageRoute(
                    builder: (context) => const AdminNotificationsScreen(),
                ),
              );
            },
          ),
          if (_unreadNotificationCount > 0)
            Positioned(
              right: 11,
              top: 11,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: const BoxConstraints(
                  minWidth: 14,
                  minHeight: 14,
                ),
                child: Text(
                  '$_unreadNotificationCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildMetricCard('Total Users', '${widget.totalUsers}', Icons.people),
              const SizedBox(height: 16),
              _buildMetricCard('Completed Transactions', '${widget.completedTransactions}', Icons.check_circle),
              const SizedBox(height: 16), // Add the notification section
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Fetch CSV from API and save locally
          await downloadCsvFromApi(context);
        },
        child: const Icon(Icons.download),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 40, color: Colors.lightBlue),
                const SizedBox(width: 16),
                Text(title, style: const TextStyle(fontSize: 18)),
              ],
            ),
            Text(value, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Future<void> downloadCsvFromApi(BuildContext context) async {
    try {
      // Replace with your API endpoint
      final response = await http.get(Uri.parse('https://api-tau-plum.vercel.app/api/jobs/export'));
      
      if (response.statusCode == 200) {
        // Get the external storage directory
        final directory = await getExternalStorageDirectory();
        final path = '${directory?.path}/admin_dashboard_data.csv';

        // Write the CSV data to the file
        final file = File(path);
        await file.writeAsBytes(response.bodyBytes); // Save the response body as bytes

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CSV file saved at: $path')),
        );
      } else {
        // Handle API error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download CSV: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      // Handle any errors that may occur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving file: ${e.toString()}')),
      );
    }
  }
}
