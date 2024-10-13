import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDetails extends StatefulWidget {
  final String posterName; // Add posterName as a parameter

  const UserDetails({super.key, required this.posterName});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  Map<String, dynamic>? userDetails;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      // Replace with your API URL
      final response = await http.get(Uri.parse('https://api-tau-plum.vercel.app/api/users/${widget.posterName}'));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            userDetails = data['data'];
            isLoading = false; // Set loading to false when data is fetched
          });
        } else {
          setState(() {
            errorMessage = data['message']; // Handle the error message
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load user details'; // Handle server errors
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e'; // Handle exceptions
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // Show loading spinner
            : errorMessage != null
                ? Center(child: Text(errorMessage!)) // Show error message
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${userDetails!['name']}', // Display user name
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Email: ${userDetails!['email']}', // Display user email
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Location: ${userDetails!['location']}', // Display user location
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Contact: ${userDetails!['contact']}', // Display user contact
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Profession: ${userDetails!['profession']}', // Display user profession
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Verified: ${userDetails!['isVerify'] == 1 ? 'Yes' : 'No'}', // Display verification status
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
      ),
    );
  }
}
