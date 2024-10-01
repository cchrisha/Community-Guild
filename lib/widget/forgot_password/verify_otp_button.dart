import 'package:flutter/material.dart';

class VerifyOtpButton extends StatelessWidget {
  final bool isVerifying;
  final VoidCallback onPressed;

  const VerifyOtpButton({
    super.key,
    required this.isVerifying,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isVerifying ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.lightBlue,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: isVerifying
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('Verify OTP'),
    );
  }
}
