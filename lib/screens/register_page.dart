import 'package:community_guild/bloc/user/auth_bloc.dart';
import 'package:community_guild/bloc/user/auth_event.dart';
import 'package:community_guild/bloc/user/auth_state.dart';
import 'package:community_guild/models/userAuth_model.dart';
import 'package:community_guild/repository/authentication/auth_repository.dart';
import 'package:community_guild/screens/login_page.dart';
import 'package:community_guild/widget/login_and_register/login_register_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// ... (rest of your imports)

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _passwordStrength = '';
  Color _strengthColor = Colors.grey;
  String _passwordError = ''; // Variable to track password match error

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository(httpClient: http.Client());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: SingleChildScrollView(
            child: BlocProvider(
              create: (_) => AuthBloc(authRepository: authRepository),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Account created successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Get.off(() => const LoginPage());
                  }
                  if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text(state.error), // Display error from backend
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final authBloc = context.read<AuthBloc>();
                  if (state is AuthLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  bool isKeyboardVisible =
                      MediaQuery.of(context).viewInsets.bottom < 50;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AuthWidgets.logo(),
                      const SizedBox(height: 5),
                      AuthWidgets.welcomeText(isLogin: false),
                      const SizedBox(height: 3),
                      AuthWidgets.textField(
                        labelText: 'Name',
                        controller: authBloc.nameController,
                        obscureText: false,
                      ),
                      const SizedBox(height: 15),
                      AuthWidgets.textField(
                        labelText: 'Email',
                        controller: authBloc.emailController,
                        obscureText: false,
                      ),
                      const SizedBox(height: 15),
                      AuthWidgets.textField(
                        labelText: 'Password',
                        controller: authBloc.passwordController,
                        obscureText: authBloc.obscureText,
                        onChanged: _checkPasswordStrength,
                        suffixIcon: IconButton(
                          icon: Icon(
                            authBloc.obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            authBloc.add(TogglePasswordVisibility());
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Display password strength only if the keyboard is visible
                      if (isKeyboardVisible) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password Strength: $_passwordStrength',
                            style: TextStyle(
                              color: _strengthColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 15),
                      AuthWidgets.textField(
                        labelText: 'Confirm Password',
                        controller: authBloc.confirmPasswordController,
                        obscureText: authBloc.obscureConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            authBloc.obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            authBloc.add(ToggleConfirmPasswordVisibility());
                          },
                        ),
                      ),
                      // Display password match error aligned to the left
                      if (_passwordError.isNotEmpty)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _passwordError,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          ),
                        ),
                      const SizedBox(height: 15),
                      AuthWidgets.textField(
                        labelText: 'Location',
                        controller: authBloc.locationController,
                        obscureText: false,
                      ),
                      const SizedBox(height: 15),
                      AuthWidgets.textField(
                        labelText: 'Contact Number',
                        controller: authBloc.contactController,
                        obscureText: false,
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      const SizedBox(height: 15),
                      AuthWidgets.textField(
                        labelText: 'Profession',
                        controller: authBloc.professionController,
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      AuthWidgets.primaryButton(
                        text: 'Sign Up',
                        onPressed: () {
                          if (authBloc.passwordController.text.isEmpty ||
                              authBloc.confirmPasswordController.text.isEmpty) {
                            setState(() {
                              _passwordError =
                                  'Please fill all required fields';
                            });
                          } else if (authBloc.passwordController.text !=
                              authBloc.confirmPasswordController.text) {
                            setState(() {
                              _passwordError = 'Passwords do not match';
                            });
                          } else {
                            setState(() {
                              _passwordError = '';
                            });
                            authBloc.add(RegisterRequested(
                              context: context,
                              userauth: Userauth(
                                id: '',
                                name: authBloc.nameController.text,
                                email: authBloc.emailController.text,
                                password: authBloc.passwordController.text,
                                location: authBloc.locationController.text,
                                contact: authBloc.contactController.text,
                                profession: authBloc.professionController.text,
                              ),
                            ));
                          }
                        },
                      ),
                      const SizedBox(height: 5),
                      AuthWidgets.navigationLink(
                        isLogin: false,
                        onPressed: () {
                          Get.to(() => const LoginPage());
                        },
                        text: 'Already Registered? Login',
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _checkPasswordStrength(String password) {
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
