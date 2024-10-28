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
    required this.category,
    required this.posterName,
    required this.posterId,
  });

  final String jobId;
  final String jobTitle;
  final String jobDescription;
  final String date;
  final String wageRange;
  final bool isCrypto;
  final String professions;
  final String workPlace;
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
        _isLoading = true;
      });

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userName = prefs.getString('user_name');

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
        body: json.encode({}),
      );

      if (response.statusCode == 200) {
        //_notifyJobPoster(widget.jobId, userName ?? '', widget.jobTitle);
        _showSuccessSnackBar();
        Navigator.pop(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${responseData['message']}'),
            backgroundColor: Colors.red,
          ),
        );
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
        _isLoading = false;
      });
    }
  }

  // Future<void> _notifyJobPoster(String jobId, String userName, String jobTitle) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString('auth_token');

  //     if (token == null) {
  //       return;
  //     }

  //     final notificationUrl = 'https://api-tau-plum.vercel.app/api/notifications';
  //     final headers = {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     };

  //     final body = json.encode({
  //       'user': widget.posterId,
  //       'message': 'User $userName applied for the job $jobTitle',
  //       'job': jobId,
  //     });

  //     final response = await http.post(
  //       Uri.parse(notificationUrl),
  //       headers: headers,
  //       body: body,
  //     );

  //     if (response.statusCode != 200) {
  //       throw Exception('Failed to notify job poster.');
  //     }
  //   } catch (e) {
  //     print('Error sending notification: $e');
  //   }
  // }

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
    backgroundColor: Colors.grey[100],
    appBar: AppBar(
      title: const Text(
        'Job Details',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF03A9F4),
      elevation: 8,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
    body: Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetails(posterName: widget.posterName),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.transparent,
                        child: Icon(Icons.person, color: Color(0xFF03A9F4), size: 36),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.posterName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(0, 0, 0, 0.867),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.date,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 0),
                const Divider(color: Color(0xFF03A9F4), thickness: 1.2),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    widget.jobTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    widget.category,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: Card(
                    color: const Color.fromARGB(255, 254, 254, 254),
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        height: 200,
                        width: 400,
                        child: SingleChildScrollView(
                          child: Text(
                            widget.jobDescription,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.work, size: 30, color: Color(0xFF03A9F4)),
                        SizedBox(width: 90),
                        Icon(Icons.location_on, size: 30, color: Color(0xFF03A9F4)),
                        SizedBox(width: 90),
                        Icon(Icons.monetization_on, size: 30, color: Color(0xFF03A9F4)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              widget.professions,
                              style: const TextStyle(fontSize: 16, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              widget.workPlace,
                              style: const TextStyle(fontSize: 16, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "${widget.wageRange} (${widget.isCrypto ? 'Crypto' : 'Not Crypto'})",
                              style: const TextStyle(fontSize: 16, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _applyForJob(widget.jobId);
                      },
                      icon: const Icon(
                        Icons.work_outline,
                        size: 24,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Apply Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF03A9F4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                        elevation: 6,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
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
  );
}


  // Helper method to build detail icon rows
  Widget _buildDetailIcon(IconData icon, String data) {
    return Column(
      children: [
        Icon(icon, size: 30, color: const Color(0xFF03A9F4)), // Icon with fixed size
        const SizedBox(height: 10), // Space between the icon and text
        SizedBox(
          width: 110, // Fixed width for the text under the icon
          child: Text(
            data.isNotEmpty ? data : (icon == Icons.money_off ? 'Not Crypto' : 'Crypto'),
            style: const TextStyle(fontSize: 16, color: Color.fromARGB(136, 0, 0, 0)),
            maxLines: 3, // Limit the text to 3 lines
            softWrap: true, // Allow text to wrap within the fixed width
            overflow: TextOverflow.ellipsis, // Add ellipsis if text exceeds 3 lines
            textAlign: TextAlign.center, // Center-align the text under the icon
          ),
        ),
      ],
    );
  }
}