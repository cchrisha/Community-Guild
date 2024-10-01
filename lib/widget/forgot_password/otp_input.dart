import 'package:flutter/material.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;

  const OtpInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Enter OTP',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: const Icon(
          Icons.lock,
          color: Colors.lightBlue,
        ),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the OTP';
        }
        return null;
      },
    );
  }
}
