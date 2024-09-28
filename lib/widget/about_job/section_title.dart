import 'package:flutter/material.dart';

class SectionTitleAboutJob extends StatelessWidget {
  final String title;

  const SectionTitleAboutJob({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
