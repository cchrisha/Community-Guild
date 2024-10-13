import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../choose.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({Key? key}) : super(key: key);

  @override
  _AdminSettingsPageState createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  bool _isLoading = false; // Variable to manage loading state

  // Logout function
  Future<void> _logout(BuildContext context) async {
    setState(() {
      _isLoading = true; // Set loading to true
    });

    try {
      // Get the saved token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token'); // Retrieve the token

      // Check if token is null or empty
      if (token == null || token.isEmpty) {
        setState(() {
          _isLoading = false; // Set loading to false if token is not found
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No valid session found. Please log in again.')),
        );
        return;
      }

      final response = await http.post(
        Uri.parse(
            'https://api-tau-plum.vercel.app/api/adminLogout'), // Your API URL
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Use the retrieved token
        },
      );

      setState(() {
        _isLoading = false; // Set loading to false after API call
      });

      if (response.statusCode == 200) {
        // Handle successful logout
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged out successfully')),
        );

        // Remove the token from SharedPreferences
        await prefs
            .remove('auth_token'); // Use the key you used to store the token

        // Navigate to ChoosePreference after logout
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const ChoosePreference()),
          (Route<dynamic> route) => false,
        );
      } else {
        // Handle error response
        final responseBody = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['message'] ?? 'Logout failed')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Set loading to false in case of error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Settings'), // Set the title of the AppBar
        centerTitle: true, // Center the title in the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Change Password'),
              leading: const Icon(Icons.lock,
                  color: Colors.lightBlue), // Added color to the icon
              onTap: () {
                // Add navigation or functionality for changing password
              },
            ),
            ListTile(
              title: const Text('Manage Users'),
              leading: const Icon(Icons.group,
                  color: Colors.lightBlue), // Added color to the icon
              onTap: () {
                // Add navigation or functionality for managing users
              },
            ),
            ListTile(
              title: const Text('App Settings'),
              leading: const Icon(Icons.settings,
                  color: Colors.lightBlue), // Added color to the icon
              onTap: () {
                // Add navigation or functionality for app settings
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout,
                  color: Colors.lightBlue), // Added color to the icon
              onTap: () {
                _logout(context); // Call logout function on tap
              },
            ),
            if (_isLoading) // Show loading indicator when logging out
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
