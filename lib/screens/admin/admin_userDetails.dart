import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminUserDetailsPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const AdminUserDetailsPage({super.key, required this.user});

  @override
  _AdminUserDetailsPageState createState() => _AdminUserDetailsPageState();
}

class _AdminUserDetailsPageState extends State<AdminUserDetailsPage> {
  late bool isVerified;

  @override
  void initState() {
    super.initState();
    isVerified = widget.user['isVerify'] == 1;
  }

  Future<void> _updateVerifyStatus(String userId, bool isVerified) async {
    final url = 'https://api-tau-plum.vercel.app/api/users/verify/$userId';

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'isVerify': isVerified ? 1 : 0}),
      );

      if (response.statusCode == 200) {
        setState(() {
          this.isVerified = isVerified;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verify status updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update verify status')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      print(e);  // Debugging output
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Information Card
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text('Name: ${widget.user['name']}', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    Text('Email: ${widget.user['email']}', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    Text('Profession: ${widget.user['profession']}', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    Text('Contact: ${widget.user['contact']}', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    Text('Location: ${widget.user['location']}', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Verified Status:', style: TextStyle(fontSize: 16)),
                        Switch(
                          value: isVerified,
                          onChanged: (bool newValue) {
                            _updateVerifyStatus(widget.user['_id'], newValue);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Recent Jobs Section
            Text(
              'Recent Jobs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Here you can fetch and display recent jobs
            // For example, use a ListView to display jobs
            _buildJobsSection('Recent Jobs', [
              // Sample recent jobs data
              {'title': 'Job Title 1', 'status': 'Posted'},
              {'title': 'Job Title 2', 'status': 'Completed'},
            ]),

            // Posted Jobs Section
            const SizedBox(height: 20),
            Text(
              'Posted Jobs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildJobsSection('Posted Jobs', [
              // Sample posted jobs data
              {'title': 'Job Title 3', 'status': 'Posted'},
              {'title': 'Job Title 4', 'status': 'Posted'},
            ]),

            // Completed Jobs Section
            const SizedBox(height: 20),
            Text(
              'Completed Jobs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildJobsSection('Completed Jobs', [
              // Sample completed jobs data
              {'title': 'Job Title 5', 'status': 'Completed'},
              {'title': 'Job Title 6', 'status': 'Completed'},
            ]),
          ],
        ),
      ),
    );
  }

  // Method to build jobs section
  Widget _buildJobsSection(String sectionTitle, List<Map<String, String>> jobs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: jobs.map((job) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            title: Text(job['title'] ?? ''),
            subtitle: Text('Status: ${job['status']}'),
          ),
        );
      }).toList(),
    );
  }
}
