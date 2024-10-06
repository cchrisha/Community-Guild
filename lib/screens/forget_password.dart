// forget_password_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/forgetpassword/forgetpassword_bloc.dart';
import '../bloc/forgetpassword/forgetpassword_event.dart';
import '../bloc/forgetpassword/forgetpassword_state.dart';
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
  bool _isPasswordVisible = false; // State for toggling password visibility

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordBloc(),
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Forgot Password'),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
            builder: (context, state) {
              if (state is OtpSending) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is OtpSent) {
                return _buildOtpInput(context);
              } else if (state is OtpVerified) {
                return _buildPasswordInput(context);
              } else if (state is PasswordResetLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PasswordResetSuccess) {
                return _buildSuccessDialog(
                    context, 'Password reset successful.');
              } else if (state is ForgetPasswordFailure) {
                return _buildErrorDialog(context, state.error);
              } else {
                return _buildEmailInput(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmailInput(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Enter your email to receive an OTP',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        EmailInput(controller: _emailController),
        const SizedBox(height: 20),
        SendOtpButton(
          isLoading: false,
          onPressed: () {
            BlocProvider.of<ForgetPasswordBloc>(context)
                .add(SendOtpEvent(email: _emailController.text));
          },
        ),
      ],
    );
  }

  Widget _buildOtpInput(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Enter the OTP sent to your email',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        OtpInput(controller: _otpController),
        const SizedBox(height: 20),
        VerifyOtpButton(
          isVerifying: false,
          onPressed: () {
            BlocProvider.of<ForgetPasswordBloc>(context)
                .add(VerifyOtpEvent(otp: _otpController.text));
          },
        ),
      ],
    );
  }

  Widget _buildPasswordInput(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Enter a new password',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        PasswordInput(
          controller: _passwordController,
          isVisible: _isPasswordVisible,
          onChanged: (password) {
            // Handle password change logic
          },
          onToggleVisibility: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        const SizedBox(height: 20),
        SendOtpButton(
          isLoading: false,
          onPressed: () {
            BlocProvider.of<ForgetPasswordBloc>(context)
                .add(ResetPasswordEvent(password: _passwordController.text));
          },
          label: 'Reset Password',
        ),
      ],
    );
  }

  Widget _buildSuccessDialog(BuildContext context, String message) {
    return AlertDialog(
      title: const Text('Success'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: const Text('OK', style: TextStyle(color: Colors.lightBlue)),
        ),
      ],
    );
  }

  Widget _buildErrorDialog(BuildContext context, String error) {
    return AlertDialog(
      title: const Text('Error'),
      content: Text(error),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK', style: TextStyle(color: Colors.lightBlue)),
        ),
      ],
    );
  }
}
