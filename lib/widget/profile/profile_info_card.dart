import 'package:flutter/material.dart';
import 'profile_info_row.dart';

class ProfileInfoCard extends StatelessWidget {
  final String location;
  final String contact;
  final String email;
  final String profession;

  const ProfileInfoCard({
    super.key,
    required this.location,
    required this.contact,
    required this.email,
    required this.profession,
  });

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileInfoRow(label: 'Location:', value: location),
          ProfileInfoRow(label: 'Contact:', value: contact),
          ProfileInfoRow(label: 'Email:', value: email),
          ProfileInfoRow(label: 'Profession:', value: profession),
        ],
      ),
    );
  }
}
