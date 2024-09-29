import 'package:flutter/material.dart';

AppBar buildJobAppBar(BuildContext context) {
  return AppBar(
    title: const Text(
      'Finishing Job',
      style: TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: Colors.lightBlue,
    elevation: 0,
    centerTitle: true,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.share, color: Colors.white),
        onPressed: () {
          // Implement share functionality
        },
      ),
    ],
  );
}
