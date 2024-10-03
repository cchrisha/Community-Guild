// lib/views/home/section_title_with_dropdown.dart
import 'package:flutter/material.dart';

class SectionTitleAboutJob extends StatelessWidget {
  final String title;

  const SectionTitleAboutJob({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
