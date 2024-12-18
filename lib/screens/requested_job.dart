import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';  

class RequestedJobDetail extends StatefulWidget {
  const RequestedJobDetail({
    super.key,
    required this.jobId,
    required this.jobTitle,
    required this.jobDescription,
    required this.date,
    required this.wageRange,
    required this.isCrypto,
    required this.professions,
    required this.workPlace,
    required this.contact,
    required this.category,
  });

  final String jobId; // Job ID for the request
  final String jobTitle;
  final String jobDescription;
  final String date;
  final String wageRange;
  final bool isCrypto;
  final String professions;
  final String workPlace;
  final String contact;
  final String category;

  @override
  State<RequestedJobDetail> createState() => _RequestedJobDetailState();
}

// Moved outside the class to avoid conflict
class _RequestedJobDetailState extends State<RequestedJobDetail> {
  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('MMMM dd, yyyy').format(parsedDate); // Format date
    } catch (e) {
      return date; // Return original date string if parsing fails
    }
  }

  // Function to handle the cancellation of the job request
  Future<void> _cancelJobRequest() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null) {
    print('Token is null. User not logged in.');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please log in to cancel the job request."),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  final url = Uri.parse('https://api-tau-plum.vercel.app/api/jobs/${widget.jobId}/request'); // Replace with your API URL

  try {
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Include the token here
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Job request canceled successfully"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context); // Go back to the previous screen
    } else {
      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseData['message'] ?? 'Failed to cancel job request'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    print("Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("An error occurred. Please try again."),
        backgroundColor: Colors.red,
      ),
    );
  }
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
       automaticallyImplyLeading: false,
      elevation: 8,
      centerTitle: true,
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.lightBlueAccent,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.contact,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
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
                  margin: EdgeInsets.zero, // Remove margin to use full width
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
                      Icon(Icons.monetization_on, size: 30, color: Color(0xFF03A9F4),),
                    ],
                  ),
                  const SizedBox(height: 10), // Space between icon row and data row
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

// Adding the Cancel Job button here
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Centers the buttons
                children: [
                  SizedBox(
                    width: 130,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Navigate back to JobPage
                      },
                      child: const Text(
                        'Back',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30), // Spacing between buttons
                  SizedBox(
                    width: 130,
                    child: ElevatedButton(
                      onPressed: _cancelJobRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent, // Button color
                        padding: const EdgeInsets.symmetric(vertical: 15), // Consistent padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        'Cancel Application',
                        style: TextStyle( color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20), // Spacing below the row
              ],
            ),
          ),
        ));
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
  Widget _buildDetailIcon(IconData icon, String data) {
    return Column(
      children: [
        Icon(icon, size: 30, color: const Color(0xFF03A9F4)), // Icon with fixed size
        const SizedBox(height: 10), // Space between the icon and text
        SizedBox(
          width: 80, // Fixed width for the text under the icon
          child: Text(
            data.isNotEmpty ? data : (icon == Icons.money_off ? 'Not Crypto' : 'Crypto'),
            style: const TextStyle(fontSize: 16, color: Color.fromARGB(137, 0, 0, 0)),
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
