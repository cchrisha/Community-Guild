import 'package:flutter/material.dart';
import 'dart:async';
import '../widget/forgot_password/custom_app_bar.dart';
import '../widget/forgot_password/email_input.dart';
import '../widget/forgot_password/otp_input.dart';
import '../widget/forgot_password/password_input.dart';
import '../widget/forgot_password/send_otp_button.dart';
import '../widget/forgot_password/verify_otp_button.dart';
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
  bool _isVerifying = false;
  bool _isPasswordVisible = false;
  String _passwordStrength = '';

  void _sendOtp() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
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
      _isVerifying = true;
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
        _isVerifying = false;
      });
    });
  }

  void _resetPassword() {
    if (_passwordController.text.length >= 8) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
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
                Navigator.pop(context);
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
      appBar: const CustomAppBar(title: 'Forgot Password'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isOtpSent) ...[
                const Text(
                  'Enter your email to receive an OTP',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                EmailInput(controller: _emailController),
                const SizedBox(height: 20),
                SendOtpButton(
                  isLoading: _isLoading,
                  onPressed: _sendOtp,
                ),
              ] else if (_isOtpSent && !_isOtpVerified) ...[
                const Text(
                  'Enter the OTP sent to your email',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                OtpInput(controller: _otpController),
                const SizedBox(height: 20),
                VerifyOtpButton(
                  isVerifying: _isVerifying,
                  onPressed: _verifyOtp,
                ),
              ] else if (_isOtpVerified) ...[
                const Text(
                  'Enter a new password',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                PasswordInput(
                  controller: _passwordController,
                  isVisible: _isPasswordVisible,
                  onChanged: _checkPasswordStrength,
                  onToggleVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
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
                SendOtpButton(
                  isLoading: _isLoading,
                  onPressed: _resetPassword,
                  label: 'Reset Password',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
