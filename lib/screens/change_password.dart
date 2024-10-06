import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/change_password/change_password_bloc.dart';
import '../bloc/change_password/change_password_event.dart';
import '../bloc/change_password/change_password_state.dart';
import '../repository/change_password_repository.dart';
import '../widget/change_password/password_field.dart';
import '../widget/change_password/password_strength_indicator.dart';
import '../widget/change_password/security_tips.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  String _passwordStrength = '';
  Color _strengthColor = Colors.grey;
  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordBloc(
        changePasswordRepository: ChangePasswordRepository(),
      ),
      child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password changed successfully'),
                backgroundColor: Colors.green,
              ),
            );
            _oldPasswordController.clear();
            _newPasswordController.clear();
            setState(() {
              _passwordStrength = '';
              _strengthColor = Colors.grey;
            });
          } else if (state is ChangePasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Change Password',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              backgroundColor: const Color.fromARGB(255, 3, 169, 244),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PasswordField(
                      controller: _oldPasswordController,
                      label: 'Old Password',
                      icon: Icons.lock_outline,
                      isVisible: _oldPasswordVisible,
                      toggleVisibility: () {
                        setState(() {
                          _oldPasswordVisible = !_oldPasswordVisible;
                        });
                      },
                    ),
                    const SizedBox(height: 20.0),
                    PasswordField(
                      controller: _newPasswordController,
                      label: 'New Password',
                      icon: Icons.lock,
                      isVisible: _newPasswordVisible,
                      toggleVisibility: () {
                        setState(() {
                          _newPasswordVisible = !_newPasswordVisible;
                        });
                      },
                      onChanged: _checkPasswordStrength,
                    ),
                    const SizedBox(height: 10.0),
                    PasswordStrengthIndicator(
                      strength: _passwordStrength,
                      strengthColor: _strengthColor,
                    ),
                    const SizedBox(height: 20.0),
                    const SecurityTips(),
                    const SizedBox(height: 30.0),
                    ElevatedButton(
                      onPressed: state is ChangePasswordLoading
                          ? null
                          : () {
                              context.read<ChangePasswordBloc>().add(
                                    ChangePasswordRequested(
                                      oldPassword: _oldPasswordController.text,
                                      newPassword: _newPasswordController.text,
                                    ),
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 3, 169, 244),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Change Password',
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                    ),
                    if (state is ChangePasswordLoading)
                      const SizedBox(height: 10.0),
                    if (state is ChangePasswordLoading)
                      const CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _checkPasswordStrength(String password) {
    // Same password strength checking logic as before...
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = '';
        _strengthColor = Colors.grey;
      });
      return;
    }

    int strength = 0;

    if (password.length >= 8) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#\$%\^&\*]').hasMatch(password)) strength++;

    switch (strength) {
      case 0:
      case 1:
        setState(() {
          _passwordStrength = 'Very Weak';
          _strengthColor = Colors.red;
        });
        break;
      case 2:
        setState(() {
          _passwordStrength = 'Weak';
          _strengthColor = Colors.orange;
        });
        break;
      case 3:
        setState(() {
          _passwordStrength = 'Moderate';
          _strengthColor = Colors.yellow;
        });
        break;
      case 4:
        setState(() {
          _passwordStrength = 'Strong';
          _strengthColor = Colors.lightGreen;
        });
        break;
      case 5:
        setState(() {
          _passwordStrength = 'Very Strong';
          _strengthColor = Colors.green;
        });
        break;
    }
  }
}
