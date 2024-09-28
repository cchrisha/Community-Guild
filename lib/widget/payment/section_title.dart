import 'package:flutter/material.dart';

class PaymentSectionTitle extends StatelessWidget {
  final String title;

  const PaymentSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
