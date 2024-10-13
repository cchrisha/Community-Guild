import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for TextInputFormatter
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
        const SizedBox(height: 5),
        Text(
          isLogin ? 'Sign in to continue' : 'Sign up to join',
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      ],
    );
  }

  static Widget textField({
    required String labelText,
    required TextEditingController controller,
    required bool obscureText,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    Function(String)? onChanged,
    FocusNode? focusNode, // Add FocusNode parameter
    IconData? icon, // Add Icon parameter
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        focusNode: focusNode, // Pass FocusNode to TextField
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.poppins(color: const Color.fromARGB(255, 0, 0, 0)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20), // Added padding here
          suffixIcon: suffixIcon,
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null, // Add icon before label text
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color.fromARGB(255, 190, 190, 190), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 1), // Focused border color
          ),
        ),
        style: GoogleFonts.poppins(),
      ),
    );
  }

  static Widget primaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity, // Ensure the button takes up full width like text fields
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20), // Adjust vertical padding if needed
          backgroundColor: Colors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
        ),
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
