import 'package:flutter/material.dart';

class AboutJobCard extends StatelessWidget {
  final String jobTitle;
  final String jobDescription;
  final String workPlace;
  final String date;
  final String wageRange;
  final bool isCrypto;
  final String professions;
  final VoidCallback onTap; 
  final bool showAddButton;

  const AboutJobCard({
    super.key, 
    required this.jobTitle,
    required this.jobDescription,
    required this.workPlace,
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
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(jobTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(date, style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                jobDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis, // Add "..." kapag maraming ka-OA-an
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Text('Wanted Profession: $professions'),
              const SizedBox(height: 10),
              Text('Workplace: $workPlace'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Wage: $wageRange'),
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
