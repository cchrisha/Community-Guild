import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
  final String name;
  final String profession;
  final String email;
  final String location;
  final String contact;
  final bool isVerified;
  final String? profilePicture; // Nullable to handle cases without a profile picture

  const UserInfoCard({
    Key? key,
    required this.name,
    required this.profession,
    required this.email,
    required this.location,
    required this.contact,
    required this.isVerified,
    this.profilePicture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar
        CircleAvatar(
          radius: 40,
          backgroundImage: profilePicture != null
              ? NetworkImage(profilePicture!)
              : null,
          child: profilePicture == null
              ? Text(
                  name.isNotEmpty ? name[0] : '?',
                  style: const TextStyle(fontSize: 40),
                )
              : null,
        ),
        const SizedBox(height: 8), // Space between avatar and name

        // Name
        Text(
          name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center, // Center-align the name
        ),
        const SizedBox(height: 4), // Space between name and profession

        // Profession
        Text(
          profession,
          style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          textAlign: TextAlign.center, // Center-align the profession
        ),
        const SizedBox(height: 16), // Space between profession and additional info

        // Additional Info Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(25.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start (left)
            children: [
              const SizedBox(height: 4), // Space between title and details
              Text('Email: $email', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
              Text('Location: $location', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
              Text('Contact: $contact', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
              Text(
                'Verified: ${isVerified ? 'Yes' : 'No'}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
