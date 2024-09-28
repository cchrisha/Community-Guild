import 'package:flutter/material.dart';

class ProfileSectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onEdit;

  const ProfileSectionTitle(
      {super.key, required this.title, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit, size: 20, color: Colors.blueAccent),
          onPressed: onEdit,
        ),
      ],
    );
  }
}
