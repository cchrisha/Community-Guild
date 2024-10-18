import 'package:flutter/material.dart';

class ProfileHeader extends StatefulWidget {
  final String name;
  final String profession;

  const ProfileHeader({
    Key? key,
    required this.name,
    required this.profession,
  }) : super(key: key);

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          widget.name,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          widget.profession,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.lightBlue,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
