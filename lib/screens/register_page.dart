import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:community_guild/bloc/auth/auth_bloc.dart';
import 'package:community_guild/bloc/auth/auth_event.dart';
import 'package:community_guild/bloc/auth/auth_state.dart';
import 'package:community_guild/screens/login_page.dart';
import 'package:community_guild/widget/login_and_register/login_register_widget.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: SingleChildScrollView(
            child: BlocProvider(
              create: (_) => AuthBloc(httpClient: http.Client()),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    Get.off(() => const LoginPage());
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  final authBloc = context.read<AuthBloc>();

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AuthWidgets.logo(),
                      const SizedBox(height: 40),
                      AuthWidgets.welcomeText(isLogin: false),
                      const SizedBox(height: 30),
                      AuthWidgets.textField(
                        hintText: 'Name',
                        controller: authBloc.nameController,
                        obscureText: false,
                      ),
                      const SizedBox(height: 15),
                      AuthWidgets.textField(
                        hintText: 'Email',
                        controller: authBloc.emailController,
                        obscureText: false,
                      ),
                      const SizedBox(height: 15),
                      AuthWidgets.textField(
                        hintText: 'Password',
                        controller: authBloc.passwordController,
                        obscureText: authBloc.obscureText,
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
                      const SizedBox(height: 15),
                      AuthWidgets.textField(
                        hintText: 'Confirm Password',
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
                      const SizedBox(height: 20),
                      AuthWidgets.primaryButton(
                        text: 'Sign Up',
                        onPressed: () {
                          if (authBloc.passwordController.text ==
                              authBloc.confirmPasswordController.text) {
                            authBloc.add(RegisterRequested(
                              name: authBloc.nameController.text,
                              email: authBloc.emailController.text,
                              password: authBloc.passwordController.text,
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Passwords do not match')),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 15),
                      AuthWidgets.navigationLink(
                        isLogin: false,
                        onPressed: () {
                          Get.to(() => const LoginPage());
                        },
                        text: 'Already Registered? Login  ',
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
}
