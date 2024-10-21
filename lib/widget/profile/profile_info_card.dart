import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  final String location;
  final String contact;
  final String email;

  const ProfileInfoCard({
    Key? key,
    required this.location,
    required this.contact,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
      child: Column(
        children: [
          // Contact Info Section
          _buildContactInfoSection(),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          ProfileInfoRow(value: email, icon: Icons.email),
          const SizedBox(height: 10),
          _buildDivider(),
          const SizedBox(height: 10),
          ProfileInfoRow(value: location, icon: Icons.location_on),
          const SizedBox(height: 10),
          _buildDivider(),
          const SizedBox(height: 10),
          ProfileInfoRow(value: contact, icon: Icons.phone),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.withOpacity(0.5),
      thickness: 1,
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String value;
  final IconData icon;

  const ProfileInfoRow({
    Key? key,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.lightBlue, // Set the icon color to light blue
          size: 24.0, // Icon size remains unchanged
        ),
        const SizedBox(width: 16.0), // Spacing between icon and text
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16.0, // Font size remains unchanged
              color: Colors.black87, // Text color
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileSectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onEdit;

  const ProfileSectionTitle({
    super.key,
    required this.title,
    required this.onEdit,
  });

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
