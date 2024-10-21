import 'dart:async'; // Importing Timer
import 'package:community_guild/repository/authentication/auth_repository.dart';
import 'package:community_guild/screens/forget_password.dart';
import 'package:community_guild/widget/loading_widget/ink_drop.dart';
import 'package:community_guild/widget/login_and_register/login_register_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:community_guild/bloc/auth/auth_bloc.dart';
import 'package:community_guild/bloc/auth/auth_event.dart';
import 'package:community_guild/bloc/auth/auth_state.dart';
import 'package:community_guild/screens/home.dart';
import 'package:community_guild/screens/register_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_token');
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository(httpClient: http.Client());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: SingleChildScrollView(
            child: BlocProvider(
              create: (_) => AuthBloc(authRepository: authRepository),
              child: FutureBuilder<bool>(
                future: _checkLoginStatus(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: InkDrop(
                        size: 40,
                        color: Colors.lightBlue,
                        ringColor: Colors.lightBlue.withOpacity(0.2),
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data == true) {
                    Future.delayed(const Duration(milliseconds: 500), () {
                      Get.off(() => const HomePage());
                    });
                    return Center(
                      child: InkDrop(
                        size: 40,
                        color: Colors.lightBlue,
                        ringColor: Colors.lightBlue.withOpacity(0.2),
                      ),
                    );
                  }

                  return BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Login successful!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Future.delayed(const Duration(seconds: 1), () {
                          Get.off(() => const HomePage());
                        });
                      } else if (state is AuthFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      final authBloc = context.read<AuthBloc>();

                      if (state is AuthLoading) {
                        return Center(
                          child: InkDrop(
                            size: 40,
                            color: Colors.lightBlue,
                            ringColor: Colors.lightBlue.withOpacity(0.2),
                          ),
                        );
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AuthWidgets.logo(),
                          const SizedBox(height: 5),
                          AuthWidgets.welcomeText(isLogin: true),
                          const SizedBox(height: 30),
                          AuthWidgets.textField(
                            labelText: 'Email',
                            controller: authBloc.emailController,
                            obscureText: false,
                            icon: Icons.email,
                          ),
                          const SizedBox(height: 20),
                          AuthWidgets.textField(
                            labelText: 'Password',
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
                            icon: Icons.lock,
                          ),
                          const SizedBox(height: 20),
                          AuthWidgets.primaryButton(
                            text: 'Login',
                            onPressed: () {
                              authBloc.add(LoginRequested(
                                email: authBloc.emailController.text,
                                password: authBloc.passwordController.text,
                              ));
                            },
                          ),
                          AuthWidgets.navigationLink(
                            isLogin: true,
                            onPressed: () {
                              Get.to(() => const RegisterPage());
                            },
                            text: 'Create new account? Signup',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AuthWidgets.forgotPasswordButton(onPressed: () {
                            Get.to(() => const ForgetPasswordPage());
                          }),
                        ],
                      );
                    },
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
