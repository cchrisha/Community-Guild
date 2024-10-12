import 'package:community_guild/screens/admin.dart';
import 'package:flutter/material.dart';
import 'package:community_guild/screens/login_page.dart';

class ChoosePreference extends StatefulWidget {
  const ChoosePreference({super.key});

  @override
  State<ChoosePreference> createState() => _ChoosePreferenceState();
}

class _ChoosePreferenceState extends State<ChoosePreference> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40), // Adjusted space at the top
              Expanded(
                child: _buildPageContent(
                  image: 'assets/images/job_hunt.png', // Replace with your admin image
                  title: 'Admin Dashboard',
                  description: 'Manage the platform, review users, and handle tasks efficiently.',
                ),
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  // Button to go to Login page
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.2),
                      backgroundColor: Colors.lightBlue,
                    ),
                    onPressed: () {
                      // Navigate to Login Page
                      Navigator.pushReplacement(
                        context,
                        _createRoute(const LoginPage()),
                      );
                    },
                    child: const Center(
                      child: Text(
                        'Go to Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Button to go to Admin page
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.2),
                      backgroundColor: Colors.green, // Admin button color
                    ),
                    onPressed: () {
                      // Navigate to Admin Page
                      Navigator.pushReplacement(
                        context,
                        _createRoute(const AdminPage()),
                      );
                    },
                    child: const Center(
                      child: Text(
                        'Go to Admin Page',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent(
      {required String image, required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 240, // Adjust the height of your image
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child; // No animation, direct transition
      },
    );
  }
}
