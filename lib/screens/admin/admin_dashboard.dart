import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'admin_notificaiton.dart';

class AdminDashboard extends StatelessWidget {
  final int totalUsers;
  final int completedTransactions;

  const AdminDashboard({
    super.key,
    required this.totalUsers,
    required this.completedTransactions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to the notification screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminNotificationsScreen()),
              );
            },
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
              _buildMetricCard('Total Users', '$totalUsers', Icons.people),
              const SizedBox(height: 16),
              _buildMetricCard('Completed Transactions', '$completedTransactions', Icons.check_circle),
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
        final path = 'storage/emulated/0/Download/admin_dashboard_data.csv';

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
