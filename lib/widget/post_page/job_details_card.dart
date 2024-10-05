import 'package:flutter/material.dart';

class JobDetailsCard extends StatelessWidget {
  final Widget child;

  const JobDetailsCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0), // Padding around the content
      child: child,
    );
  }
}
