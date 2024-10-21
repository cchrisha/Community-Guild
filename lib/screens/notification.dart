import 'package:community_guild/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widget/loading_widget/ink_drop.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // Mock API URL for fetching notifications
  final String apiUrl = 'https://example.com/notifications';

  Future<List<String>> fetchNotifications() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Assume the API returns a JSON array of strings (messages)
      List<dynamic> data = json.decode(response.body);
      return data.cast<String>(); // Convert dynamic list to List<String>
    } else {
      throw Exception('Failed to load notifications');
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
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchNotifications(), // Fetch notifications from the API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: InkDrop(
                size: 40.0,
                color: Colors.lightBlue,
                ringColor: Colors.lightBlue.withOpacity(0.1),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load notifications'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No new notifications',
                    style: TextStyle(fontSize: 20)));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                String notificationMessage = snapshot.data![index];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      notificationMessage,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
