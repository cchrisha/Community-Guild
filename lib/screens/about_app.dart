import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About the App',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // App Icon and Title Section
            Center(
              child: Column(
                children: [
                  // Placeholder for app icon
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.lightBlue.withOpacity(0.1),
                    ),
                    child: const Icon(
                      Icons.people_alt,
                      size: 80,
                      color: Colors.lightBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Community Guild',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Freelancer Collaboration App',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // About the App Section
            Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Community Guild',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Community Guild is designed to connect freelancers and clients. It offers a platform for collaboration, job management, and secure payments. Whether you’re looking to hire professionals or find freelance work, this app makes the process smooth and efficient.',
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),

            // Features Section
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Key Features',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                ),
              ),
            ),

            const Column(
              children: [
                // Feature 1
                ListTile(
                  leading: Icon(Icons.work_outline, color: Colors.lightBlue),
                  title: Text(
                    'Post and manage freelance jobs',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                // Feature 2
                ListTile(
                  leading: Icon(Icons.people_outline, color: Colors.lightBlue),
                  title: Text(
                    'Browse freelancers and available jobs',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                // Feature 3
                ListTile(
                  leading:
                      Icon(Icons.payment_outlined, color: Colors.lightBlue),
                  title: Text(
                    'Secure payment systems',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                // Feature 4
                ListTile(
                  leading: Icon(Icons.track_changes_outlined,
                      color: Colors.lightBlue),
                  title: Text(
                    'Track job progress and status updates',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                // Feature 5
                ListTile(
                  leading:
                      Icon(Icons.star_border_outlined, color: Colors.lightBlue),
                  title: Text(
                    'User profiles with reviews and ratings',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
