import 'package:flutter/material.dart';
import 'profile_info_row.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileInfoRow(label: 'Location:', value: 'New York'),
          ProfileInfoRow(label: 'Contact:', value: '123-456-7890'),
          ProfileInfoRow(
            label: 'Email:',
            value: 'marvin@gmail.com',
          ),
          ProfileInfoRow(label: 'Profession:', value: 'Software Developer'),
        ],
      ),
    );
  }
}
