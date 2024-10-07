import 'package:flutter/material.dart';

class SecurityTips extends StatelessWidget {
  const SecurityTips({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Security Tips:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        SizedBox(height: 5),
        Text('• Use at least 8 characters.'),
        Text('• Include upper and lower case letters.'),
        Text('• Add numbers and special characters.'),
        Text('• Avoid common words or personal info.'),
        Text('• Do not reuse passwords.'),
      ],
    );
  }
}
