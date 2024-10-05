import 'package:flutter/material.dart';

class JobDetailsHeader extends StatelessWidget {
  final String title;

  const JobDetailsHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 3, 169, 244),
      ),
    );
  }
}
