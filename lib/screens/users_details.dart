import 'package:community_guild/widget/loading_widget/ink_drop.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:community_guild/repository/profile_repository.dart'; // Import the repository

class UserDetails extends StatefulWidget {
  final String posterName;

  UserDetails({required this.posterName});

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  Map<String, dynamic>? userDetails;
  bool isLoading = true;
  String? errorMessage;
  String? profilePictureUrl; // Add this for profile picture
  final ProfileRepository _profileRepository = ProfileRepository(); // Initialize ProfileRepository

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

Future<void> _fetchUserDetails() async {
  setState(() {
    isLoading = true;
    errorMessage = null;
  });

  try {
    print('Fetching details for user: ${widget.posterName}');

    final response = await http.get(
      Uri.parse('https://api-tau-plum.vercel.app/api/users/${widget.posterName}')
    );

    print('User Details API Response: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          userDetails = data['data'];
        });

        // Get the user's ObjectId from the response
        final String userId = userDetails!['_id'];  // Assuming the field is '_id'

        // Fetch the profile picture using the user's ObjectId
        final fetchedProfilePictureUrl = await _profileRepository.fetchotherProfilePicture(
          userId: userId // Pass the ObjectId here, not the name
        );

        print('Profile Picture URL: $fetchedProfilePictureUrl');

        setState(() {
          profilePictureUrl = fetchedProfilePictureUrl.isNotEmpty
              ? fetchedProfilePictureUrl
              : 'https://via.placeholder.com/150'; // Default image if none
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
      body: isLoading
          ? const Center(
              child: InkDrop(
                size: 40,
                color: Colors.lightBlue,
              ),
            )
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : _buildUserDetails(),
    );
  }

  Widget _buildUserDetails() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromARGB(255, 3, 169, 244),
                    width: 4,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      profilePictureUrl ?? 'https://via.placeholder.com/150',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                userDetails!['name'],
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Contact Info',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 6,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.email,
                        color: Color.fromARGB(255, 3, 169, 244),
                      ),
                      title: Text(userDetails!['email']),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.location_on,
                        color: Color.fromARGB(255, 3, 169, 244),
                      ),
                      title: Text(userDetails!['location']),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.phone,
                        color: Color.fromARGB(255, 3, 169, 244),
                      ),
                      title: Text(userDetails!['contact']),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Professional Info',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 6,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.work,
                        color: Color.fromARGB(255, 3, 169, 244),
                      ),
                      title: Text(userDetails!['profession']),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.verified,
                        color: Color.fromARGB(255, 3, 169, 244),
                      ),
                      title: Text(
                          'Verified: ${userDetails!['isVerify'] == 1 ? 'Yes' : 'No'}'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
