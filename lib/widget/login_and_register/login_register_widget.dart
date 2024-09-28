import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthWidgets {
  static Widget logo() {
    return Image.asset(
      'assets/images/logo1.png',
      width: 100,
      height: 100,
    );
  }

  static Widget welcomeText({required bool isLogin}) {
    return Column(
      children: [
        Text(
          isLogin ? 'Welcome Back' : 'Welcome User',
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          isLogin ? 'Sign in to continue' : 'Sign up to join',
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      ],
    );
  }

  static Widget textField({
    required String hintText,
    required TextEditingController controller,
    required bool obscureText,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color.fromARGB(255, 203, 228, 240), // Stroke color
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon: suffixIcon,
        ),
        style: GoogleFonts.poppins(),
      ),
    );
  }

  static Widget primaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
      ),
    );
  }

  static Widget navigationLink({
    required String text,
    required VoidCallback onPressed,
    required bool isLogin,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
      ),
    );
  }

  static Widget forgotPasswordButton({required VoidCallback onPressed}) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        'Forgot Password?',
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
      ),
    );
  }
}
