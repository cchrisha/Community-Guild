import 'package:flutter/material.dart';  // Ensure this import is present

class HomeJobCard extends StatelessWidget {
  final String jobTitle;
  final String jobDescription;
  final String location;
  final String date;
  final String wageRange;
  final bool isCrypto;
  final String professions;
  final VoidCallback onTap;  // VoidCallback is a typedef for a function with no arguments that returns nothing
  final bool showAddButton;

  const HomeJobCard({
    super.key,  // This is valid only if the class extends StatelessWidget or StatefulWidget
    required this.jobTitle,
    required this.jobDescription,
    required this.location,
    required this.date,
    required this.wageRange,
    required this.isCrypto,
    required this.professions,
    required this.onTap,
    this.showAddButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(jobTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(jobDescription),
              const SizedBox(height: 8),
              Text('Location: $location'),
              Text('Date: $date'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Wage: $wageRange'),
                  Checkbox(value: isCrypto, onChanged: null),
                  const Text('Crypto'),
                ],
              ),
              const SizedBox(height: 8),
              Text('Professions: $professions'),
            ],
          ),
        ),
      ),
    );
  }
}
