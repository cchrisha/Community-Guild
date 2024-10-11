import 'package:community_guild/bloc/user/auth_bloc.dart';
import 'package:community_guild/bloc/user/auth_event.dart';
import 'package:community_guild/bloc/user/auth_state.dart';
import 'package:community_guild/models/userAuth_model.dart';
import 'package:community_guild/repository/authentication/auth_repository.dart';
import 'package:community_guild/screens/login_page.dart';
import 'package:community_guild/widget/login_and_register/login_register_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
                      const SizedBox(height: 15),
                      AuthWidgets.textField(
                        labelText: 'Location',
                        controller: authBloc.locationController,
                        obscureText: false,
                      ),
                      const SizedBox(height: 15),
                      AuthWidgets.textField(
                        labelText: 'Contact',
                        controller: authBloc.contactController,
                        obscureText: false,
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
                          if (authBloc.passwordController.text ==
                                  authBloc.confirmPasswordController.text &&
                              authBloc.locationController.text.isNotEmpty &&
                              authBloc.contactController.text.isNotEmpty &&
                              authBloc.professionController.text.isNotEmpty) {
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
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please fill all required fields'),
                                backgroundColor: Colors.red,
                              ),
                            );
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
}
