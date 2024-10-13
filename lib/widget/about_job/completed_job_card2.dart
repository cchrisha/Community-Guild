import 'package:flutter/material.dart';

class CompletedJobCard2 extends StatelessWidget {
  final String jobTitle;
  final String jobDescription;
  final String workPlace;
  final String date;
  final String wageRange;
  final String category;
  final bool isCrypto;
  final String contact;
  final String professions;
  final VoidCallback onTap;
  final bool showAddButton;

  const CompletedJobCard2({
    super.key,
    required this.jobTitle,
    required this.jobDescription,
    required this.workPlace,
    required this.date,
    required this.wageRange,
    required this.contact,
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
        elevation: 3,
        color: Colors.white, // Set the background color to white
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
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
                  const SizedBox(width: 8), // Add spacing between title and date
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
              const SizedBox(height: 5),
              Text('Contact: $contact'),
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
