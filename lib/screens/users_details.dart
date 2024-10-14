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
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.red, size: 60),
                        const SizedBox(height: 16),
                        Text(errorMessage!,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.red)),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Image at the top
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            userDetails!['profilePicture'] ??
                                'https://via.placeholder.com/150'),
                      ),
                      const SizedBox(height: 16),

                      // User Name
                      Text(
                        userDetails!['name'],
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),

                      // User Profession
                      Text(
                        userDetails!['profession'],
                        style:
                            const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),

                      // Details Cards
                      Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.email, color: Colors.blue),
                          title: const Text('Email'),
                          subtitle: Text(userDetails!['email']),
                        ),
                      ),
                      Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.location_on,
                              color: Colors.green),
                          title: const Text('Location'),
                          subtitle: Text(userDetails!['location']),
                        ),
                      ),
                      Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading:
                              const Icon(Icons.phone, color: Colors.orange),
                          title: const Text('Contact'),
                          subtitle: Text(userDetails!['contact']),
                        ),
                      ),
                      Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.verified_user,
                              color: Colors.purple),
                          title: const Text('Verified'),
                          subtitle: Text(
                              userDetails!['isVerify'] == 1 ? 'Yes' : 'No'),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
