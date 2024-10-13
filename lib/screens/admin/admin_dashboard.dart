import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  final int totalUsers;
  final int completedTransactions;

  const AdminDashboard({
    Key? key,
    required this.totalUsers,
    required this.completedTransactions,
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'), // Set the title of the AppBar
        centerTitle: true, // Center the title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Removed the title Text widget, as it is now in the AppBar
              const SizedBox(height: 16),
              // Metric cards
              _buildMetricCard('Total Users', '$totalUsers', Icons.people),
              const SizedBox(height: 16),
              _buildMetricCard('Completed Transactions',
                  '$completedTransactions', Icons.check_circle),
            ],
          ),
        ),
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
}
