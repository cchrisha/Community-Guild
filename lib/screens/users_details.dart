import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
        backgroundColor: const Color.fromARGB(255, 3, 169, 244),
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
                ? Center(
                    child: Text(errorMessage!,
                        style: const TextStyle(color: Colors.red)))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display user profile picture
                        Center(
                          child: Container(
                            width: 150, // Outer container size
                            height: 150, // Outer container size
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color.fromARGB(255, 3, 169, 244), // Light blue outline
                                width: 2, // Thickness of the light blue outline
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(4), // White space between avatar and border
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white, // White background for the space
                              ),
                              child: CircleAvatar(
                                radius: 60, // Adjust radius for the avatar
                                backgroundImage: NetworkImage(
                                  userDetails!['profilePicture'] ?? 'https://via.placeholder.com/150',
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            userDetails!['name'],
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center, // Center-align the name
                          ),
                        ),
                        const SizedBox(height: 8),
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: const Icon(Icons.email),
                            title: Text(userDetails!['email']),
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: const Icon(Icons.location_on),
                            title: Text(userDetails!['location']),
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: const Icon(Icons.phone),
                            title: Text(userDetails!['contact']),
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: const Icon(Icons.work),
                            title: Text(userDetails!['profession']),
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: const Icon(Icons.verified),
                            title: Text(
                              'Verified: ${userDetails!['isVerify'] == 1 ? 'Yes' : 'No'}',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
