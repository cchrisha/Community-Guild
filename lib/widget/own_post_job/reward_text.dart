import 'package:flutter/material.dart';

class RewardText extends StatelessWidget {
  const RewardText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Reward: P1000.00',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}
