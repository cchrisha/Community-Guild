import 'package:flutter/material.dart';

class HomeJobCard extends StatelessWidget {
  final String jobTitle;
  final String jobDescription;
  final String workPlace;
  final String date;
  final String wageRange;
  final String category;
  final bool isCrypto;
  final String professions;
  final VoidCallback onTap;
  final bool showAddButton;

  const HomeJobCard({
    super.key,
    required this.jobTitle,
    required this.jobDescription,
    required this.workPlace,
    required this.date,
    required this.wageRange,
    required this.category,
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
        elevation: 5,
        color: Colors.white, // Set the background color to white
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Remove the border radius
        margin: const EdgeInsets.symmetric(vertical: 0), // Add vertical spacing between cards
        child: Container(
          width: MediaQuery.of(context).size.width, // Set the width to cover the entire screen
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      jobTitle,
                      maxLines: 1, // Limit to 1 line
                      overflow: TextOverflow.ellipsis, // Handle overflow
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                      width: 8), // Add spacing between title and date
                  Text(date, style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                jobDescription,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Text('Wanted Profession: $professions'),
              const SizedBox(height: 5),
              Text('Category: $category'),
              const SizedBox(height: 5),
              Text('Workplace: $workPlace'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    // Ensure Wage takes equal space like Workplace
                    child: Text('Wage: $wageRange'),
                  ),
                  Row(
                    children: [
                      Checkbox(value: isCrypto, onChanged: null),
                      const Text('Crypto'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
