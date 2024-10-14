import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:community_guild/widget/users_details/user_details_widget.dart'; // Import the UserInfoCard

class UserDetails extends StatefulWidget {
  final String posterName;

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
      final response = await http.get(Uri.parse(
          'https://api-tau-plum.vercel.app/api/users/${widget.posterName}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            userDetails = data['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = data['message'];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load user details';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Details',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(child: Text(errorMessage!)) // Show error message
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${userDetails!['name']}', // Display user name
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
