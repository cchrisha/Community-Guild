import 'package:community_guild/repository/auth_repository.dart';
import 'package:community_guild/screens/forget_password.dart';
import 'package:community_guild/widget/login_and_register/login_register_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:community_guild/bloc/user/auth_bloc.dart';
import 'package:community_guild/bloc/user/auth_event.dart';
import 'package:community_guild/bloc/user/auth_state.dart';
import 'package:community_guild/screens/home.dart';
import 'package:community_guild/screens/register_page.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                        content: Text("Login successful!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Future.delayed(const Duration(seconds: 1), () {
                      Get.off(() => const HomePage());
                    });
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  final authBloc = context.read<AuthBloc>();

                  if (state is AuthLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AuthWidgets.logo(),
                      const SizedBox(height: 40),
                      AuthWidgets.welcomeText(isLogin: true),
                      const SizedBox(height: 30),
                      AuthWidgets.textField(
                        hintText: 'Email',
                        controller: authBloc.emailController,
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 10),
                      AuthWidgets.navigationLink(
                        isLogin: true,
                        onPressed: () {
                          Get.to(() => const RegisterPage());
                        },
                        text: 'Create new account? Signup',
                      ),
                      const SizedBox(height: 20),
                      AuthWidgets.forgotPasswordButton(onPressed: () {
                        Get.to(() => const ForgetPasswordPage());
                      }),
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
