import 'package:flutter/material.dart';

class ProfessionInfoCard extends StatelessWidget {
  final String profession;

  const ProfessionInfoCard({
    Key? key,
    required this.profession,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: Container(
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
        child: Row(
          children: [
            const Icon(Icons.work, color: Colors.lightBlue),
            const SizedBox(
                width: 10), // Changed height to width for proper spacing
            Text(
              profession,
              // Removed font styling
            ),
          ],
        ),
      ),
    );
  }
}
