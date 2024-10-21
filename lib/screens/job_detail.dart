import 'package:community_guild/screens/home.dart';
import 'package:community_guild/screens/users_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/loading_widget/ink_drop.dart';

class JobDetailPage extends StatefulWidget {
  const JobDetailPage({
    super.key,
    required this.jobId,
    required this.jobTitle,
    required this.jobDescription,
    required this.date,
    required this.wageRange,
    required this.isCrypto,
    required this.professions,
    required this.workPlace,
    //required this.contact,
    required this.category,
    required this.posterName,
    required this.posterId, // Add this
  });

  final String jobId;
  final String jobTitle;
  final String jobDescription;
  final String date;
  final String wageRange;
  final bool isCrypto;
  final String professions;
  final String workPlace;
  //final String contact;
  final String category;
  final String posterName;
  final String posterId;

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  bool _isLoading = false;

  Future<void> _applyForJob(String jobId) async {
    try {
      setState(() {
        _isLoading = true; // Show loading spinner
      });

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userName =
          prefs.getString('user_name'); // Get the current user's name

      // Log token and userName for debugging
      print('Token: $token');
      print('User Name: $userName');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: You must be logged in to apply for a job.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final url = 'https://api-tau-plum.vercel.app/api/jobs/$jobId/request';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode({}), // Include any necessary body data if needed
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}'); // Log the full response body

      if (response.statusCode == 200) {
        // After successfully applying, notify the poster
        _notifyJobPoster(widget.jobId, userName ?? '', widget.jobTitle);

        _showSuccessSnackBar();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        final responseData = json.decode(response.body);
        print(
            'Error Response Data: $responseData'); // Log the error response data

        if (responseData['message'] == "You cannot apply to your own job") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: You cannot apply to your own job.'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${responseData['message']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading spinner
      });
    }
  }

// Notify the poster of the job
  Future<void> _notifyJobPoster(
      String jobId, String userName, String jobTitle) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      print('Notify Token: $token');
      print('Notify User Name: $userName');
      print('Job Title: $jobTitle');

      if (token == null) {
        return;
      }

      final notificationUrl =
          'https://api-tau-plum.vercel.app/api/notifications';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Update notification data to match backend expectations
      final body = json.encode({
        'user': widget.posterId, // Assuming you have the poster's ID available
        'message': 'User $userName applied for the job $jobTitle',
        'job': jobId, // This should include the job ID as well
      });

      final response = await http.post(
        Uri.parse(notificationUrl),
        headers: headers,
        body: body,
      );

      print('Notification Response Status Code: ${response.statusCode}');
      print('Notification Response Body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to notify job poster.');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Success: Wait for the response of the user'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background for a sleek look
      appBar: AppBar(
        title: const Text(
          'Job Details',
          style: TextStyle(
            fontSize: 24, // Increased font size for better readability
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 4.0,
                color: Colors.black38,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 8, // Increased elevation for a more defined AppBar
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 20), // Improved padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    height: 140, // Height for a prominent header
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.lightBlueAccent, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(30)),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: () {
                        // View profile functionality
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserDetails(posterName: widget.posterName),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Increased border radius for a softer look
                        ),
                        elevation: 8,
                        shadowColor: Colors.black26,
                        child: Container(
                          padding: const EdgeInsets.all(
                              16), // Increased padding for better touch targets
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius:
                                    36, // Slightly increased avatar size for better visibility
                                backgroundColor: Colors.blueAccent,
                                child: Icon(Icons.person,
                                    color: Colors.white, size: 36),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.posterName,
                                    style: const TextStyle(
                                      fontSize: 22, // Increased font size
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "View Profile",
                                    style: TextStyle(
                                      fontSize: 16, // Increased font size
                                      color: Colors.lightBlue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                widget.jobTitle,
                style: const TextStyle(
                  fontSize: 24, // Increased font size for job title
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(color: Colors.black26, thickness: 1.2),
              const SizedBox(height: 10),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 20, // Increased font size
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.jobDescription,
                style: const TextStyle(
                    fontSize: 16, color: Colors.black54), // Increased font size
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.black26, thickness: 1.2),
              const SizedBox(height: 16),
              const Text(
                'Details',
                style: TextStyle(
                  fontSize: 20, // Increased font size
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              _buildDetailRow('Wage Range:', widget.wageRange),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Crypto: ', style: TextStyle(fontSize: 16)),
                  Checkbox(
                    value: widget.isCrypto,
                    onChanged: (bool? value) {},
                    activeColor: Colors.blueAccent,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildDetailRow('Date:', widget.date),
              const SizedBox(height: 8),
              _buildDetailRow('Wanted Profession:', widget.professions),
              const SizedBox(height: 8),
              _buildDetailRow('Workplace:', widget.workPlace),
              const SizedBox(height: 8),
              _buildDetailRow('Category:', widget.category),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _applyForJob(widget.jobId);
                  },
                  icon: const Icon(
                    Icons.work_outline,
                    size: 24, // Slightly increased icon size
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Apply Now',
                    style: TextStyle(
                      fontSize: 18, // Increased font size
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Increased border radius
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 28), // Increased padding
                    elevation: 6,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                Center(
                  child: InkDrop(
                    size: 40,
                    color: Colors.lightBlue,
                    ringColor: Colors.lightBlue.withOpacity(0.2),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

// Helper method to build detail rows
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
