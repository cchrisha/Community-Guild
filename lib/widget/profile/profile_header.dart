import 'package:community_guild/widget/profile/profile_info_card.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            // Profile image
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/profile.png'),
              backgroundColor: Colors.lightBlue,
              child: Icon(Icons.person, color: Colors.white, size: 60),
            ),
            // Profile icon
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.lightBlue,
                ),
                child: IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  onPressed: () {
                    // Add action here
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Marvin John D. Macam',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        const ProfileInfoCard(),
      ],
    );
  }
}
