import 'package:community_guild/bloc/forgetpassword/forgetpassword_event.dart';
import 'package:community_guild/widget/forgot_password/custom_app_bar.dart';
import 'package:community_guild/widget/forgot_password/email_input.dart';
import 'package:community_guild/widget/forgot_password/otp_input.dart';
import 'package:community_guild/widget/forgot_password/password_input.dart';
import 'package:community_guild/widget/forgot_password/send_otp_button.dart';
import 'package:community_guild/widget/forgot_password/verify_otp_button.dart';
import 'package:community_guild/bloc/forgetpassword/forgetpassword_bloc.dart';
import 'package:community_guild/bloc/forgetpassword/forgetpassword_state.dart';
import 'package:community_guild/repository/authentication/forgotpass_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordBloc(
        repository: ForgetPasswordRepository(),
      ),
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Forgot Password'),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
            builder: (context, state) {
              if (state is SendingOtpState ||
                  state is OtpVerificationLoading ||
                  state is PasswordResetLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is OtpSentState) {
                return _buildOtpInput(context);
              } else if (state is OtpVerified) {
                return _buildPasswordInput(context);
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
        const Text('Enter your email to receive an OTP',
            textAlign: TextAlign.center),
        const SizedBox(height: 20),
        EmailInput(controller: _emailController),
        const SizedBox(height: 20),
        SendOtpButton(
          isLoading: false,
          onPressed: () {
            if (_emailController.text.isEmpty ||
                !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(_emailController.text)) {
              _buildErrorDialog(context, 'Please enter a valid email');
              return;
            }
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
        const Text('Enter the OTP sent to your email',
            textAlign: TextAlign.center),
        const SizedBox(height: 20),
        OtpInput(controller: _otpController),
        const SizedBox(height: 20),
        VerifyOtpButton(
          isVerifying: false,
          onPressed: () {
            if (_otpController.text.isEmpty) {
              _buildErrorDialog(context, 'Please enter the OTP');
              return;
            }
            BlocProvider.of<ForgetPasswordBloc>(context).add(VerifyOtpEvent(
              email: _emailController.text,
              otp: _otpController.text,
              newPassword: '',
            ));
          },
        ),
      ],
    );
  }

  Widget _buildPasswordInput(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Enter a new password', textAlign: TextAlign.center),
        const SizedBox(height: 20),
        PasswordInput(
          controller: _passwordController,
          isVisible: _isPasswordVisible,
          onChanged: (value) {},
          onToggleVisibility: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_passwordController.text.isEmpty ||
                _passwordController.text.length < 4) {
              _buildErrorDialog(
                  context, 'Password should be at least 4 characters long');
              return;
            }
            BlocProvider.of<ForgetPasswordBloc>(context).add(ResetPasswordEvent(
              email: _emailController.text,
              newPassword: _passwordController.text,
            ));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Reset Password'),
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
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: const Text('OK'),
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
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
