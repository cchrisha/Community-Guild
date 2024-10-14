// lib/views/home/section_title_with_dropdown.dart
import 'package:flutter/material.dart';

// Enhanced SectionTitleAboutJob Widget
class SectionTitleAboutJob extends StatelessWidget {
  final String title;

  const SectionTitleAboutJob({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(10), // Rounded corners
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.work, // Example icon
                size: 28.0,
                color: Colors.lightBlue,
              ),
              const SizedBox(width: 12.0),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.chevron_right,
              color: Colors.lightBlue,
              size: 28.0,
            ),
            onPressed: () {
              // Handle tap action if necessary
            },
          ),
        ],
      ),
    );
  }
}
