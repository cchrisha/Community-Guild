import 'package:flutter/material.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String strength;
  final Color strengthColor;

  const PasswordStrengthIndicator({
    super.key,
    required this.strength,
    required this.strengthColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password Strength: $strength',
          style: TextStyle(color: strengthColor),
        ),
        const SizedBox(height: 5.0),
        LinearProgressIndicator(
          value: _getStrengthValue(strength),
          backgroundColor: Colors.grey[300],
          color: strengthColor,
        ),
      ],
    );
  }

  double _getStrengthValue(String strength) {
    switch (strength) {
      case 'Very Weak':
        return 0.2;
      case 'Weak':
        return 0.4;
      case 'Moderate':
        return 0.6;
      case 'Strong':
        return 0.8;
      case 'Very Strong':
        return 1.0;
      default:
        return 0.0;
    }
  }
}
