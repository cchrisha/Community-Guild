import 'package:flutter/material.dart';
import 'dart:async';

import 'login_page.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isOtpSent = false;
  bool _isOtpVerified = false;
  bool _isLoading = false;
  bool _isVerifying = false; // Added for OTP verification loading state
  bool _isPasswordVisible = false;
  String _passwordStrength = '';

  void _sendOtp() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      // Simulate OTP send logic
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
          _isOtpSent = true;
        });
        _showDialog('OTP Sent', 'An OTP has been sent to your email.');
      });
    }
  }

  void _verifyOtp() {
    setState(() {
      _isVerifying = true; // Show loading spinner when verifying OTP
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (_otpController.text == '123456') {
        setState(() {
          _isOtpVerified = true;
        });
        _showDialog('OTP Verified', 'You can now reset your password.');
      } else {
        _showDialog('Error', 'Invalid OTP. Please try again.');
      }
      setState(() {
        _isVerifying = false; // Hide loading spinner
      });
    });
  }

  void _resetPassword() {
    if (_passwordController.text.length >= 8) {
      setState(() {
        _isLoading = true;
      });

      // Simulate password reset logic
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        // Show success dialog with navigation to login page on 'OK' click
        _showSuccessDialog(
            'Success', 'Your password has been reset successfully.');
      });
    } else {
      _showDialog('Error', 'Password must be at least 8 characters long.');
    }
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.lightBlue),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.lightBlue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _checkPasswordStrength(String password) {
    if (password.length < 6) {
      _passwordStrength = 'Weak';
    } else if (password.length < 8) {
      _passwordStrength = 'Medium';
    } else {
      _passwordStrength = 'Strong';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isOtpSent)
                Column(
                  children: [
                    const Text(
                      'Enter your email to receive an OTP',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.lightBlue,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _sendOtp,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              backgroundColor: Colors.lightBlue,
                            ),
                            child: const Text(
                              'Send OTP',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ],
                ),
              if (_isOtpSent && !_isOtpVerified)
                Column(
                  children: [
                    const Text(
                      'Enter the OTP sent to your email',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _otpController,
                      decoration: InputDecoration(
                        hintText: 'Enter OTP',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.lightBlue,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    _isVerifying
                        ? const CircularProgressIndicator() // Loading indicator for OTP verification
                        : ElevatedButton(
                            onPressed: _verifyOtp,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              backgroundColor: Colors.lightBlue,
                            ),
                            child: const Text(
                              'Verify OTP',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ],
                ),
              if (_isOtpVerified)
                Column(
                  children: [
                    const Text(
                      'Enter a new password',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      onChanged: _checkPasswordStrength,
                      decoration: InputDecoration(
                        hintText: 'New Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.lightBlue,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Password Strength: $_passwordStrength',
                      style: TextStyle(
                        color: _passwordStrength == 'Strong'
                            ? Colors.green
                            : _passwordStrength == 'Medium'
                                ? Colors.orange
                                : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _resetPassword,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              backgroundColor: Colors.lightBlue,
                            ),
                            child: const Text(
                              'Reset Password',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
