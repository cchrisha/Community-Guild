import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AdminUserDetailsPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const AdminUserDetailsPage({super.key, required this.user});

  @override
  _AdminUserDetailsPageState createState() => _AdminUserDetailsPageState();
}

class _AdminUserDetailsPageState extends State<AdminUserDetailsPage> {
  late bool isVerified;
  List<dynamic> currentJobs = [];
  List<dynamic> completedJobs = [];
  List<dynamic> requestedJobs = [];
  List<dynamic> rejectedJobs = [];

  @override
  void initState() {
    super.initState();
    isVerified = widget.user['isVerify'] == 1;
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    try {
      final response = await http.get(
        Uri.parse('https://api-tau-plum.vercel.app/api/user/${widget.user['_id']}/jobs/all'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          currentJobs = data['current'] ?? [];
          completedJobs = data['completed'] ?? [];
          requestedJobs = data['requested'] ?? [];
          rejectedJobs = data['rejected'] ?? [];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load jobs')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Update verification status
  Future<void> _updateVerifyStatus(String userId, bool newStatus) async {
    final url = 'https://api-tau-plum.vercel.app/api/user/$userId/verify';

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No authentication token found')),
        );
        return;
      }

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'isVerify': newStatus ? 1 : 0}),
      );

      if (response.statusCode == 200) {
        setState(() {
          isVerified = newStatus;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification status updated to ${newStatus ? "verified" : "unverified"}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update verification status')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Information Card with verification toggle
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profile Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text('Name: ${widget.user['name']}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    Text('Email: ${widget.user['email']}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    Text('Profession: ${widget.user['profession']}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    Text('Contact: ${widget.user['contact']}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    Text('Location: ${widget.user['location']}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Verified Status:', style: TextStyle(fontSize: 16)),
                        Switch(
                          value: isVerified,
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey[300],
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
            _buildJobsSection('Current Jobs', currentJobs),
            _buildJobsSection('Completed Jobs', completedJobs),
            _buildJobsSection('Requested Jobs', requestedJobs),
            _buildJobsSection('Rejected Jobs', rejectedJobs),
          ],
        ),
      ),
    );
  }

  Widget _buildJobsSection(String sectionTitle, List<dynamic> jobs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sectionTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
          height: 240,
          child: jobs.isNotEmpty
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        width: 300,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job['jobTitle'],
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              job['description'],
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Center(child: Text('No jobs available in this section')),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
