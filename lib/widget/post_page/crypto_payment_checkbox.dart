import 'package:flutter/material.dart';

class CryptoPaymentCheckbox extends StatelessWidget {
  final bool isCrypto;
  final ValueChanged<bool?> onChanged;

  const CryptoPaymentCheckbox({
    super.key,
    required this.isCrypto,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: const Text(
        'Accept Cryptocurrency Payments',
        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0),),
      ),
      value: isCrypto,
      onChanged: onChanged,
    );
  }
}
