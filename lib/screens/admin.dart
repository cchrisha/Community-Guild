import 'dart:async'; // Importing Timer
import 'dart:convert';
import 'package:community_guild/screens/adminHome.dart'; // Import AdminHomePage
import 'package:community_guild/screens/login_page.dart';
import 'package:community_guild/widget/login_and_register/login_register_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_token');
  }

  Future<void> _adminLogin() async {
  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });

  // Proceed with admin login
  final authRepository = AuthRepository(httpClient: http.Client());
  final response = await authRepository.adminLogin(
    _emailController.text,
    _passwordController.text,
  );

  if (response['isAdmin'] == 0) {
    // Not an admin
    setState(() {
      _errorMessage = "You're not an admin";
      _isLoading = false;
    });
  } else if (response['isAdmin'] == 1) {
    // Successful admin login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Admin login successful!"),
        backgroundColor: Colors.green,
      ),
    );

    // Redirect to AdminHomePage after a brief delay
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminHomePage()),
      );
    });
  } else {
    // Handle login error
    setState(() {
      _errorMessage = response['message'];
      _isLoading = false;
    });
  }

  // Ensure loading state is reset if not logging in
  if (response['isAdmin'] != 1) {
    setState(() {
      _isLoading = false;
    });
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: SingleChildScrollView(
            child: FutureBuilder<bool>(
              future: _checkLoginStatus(),
              builder: (context, snapshot) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuthWidgets.logo(),
                    const Text(
                      "Welcome Admin!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 30),
                    AuthWidgets.textField(
                      labelText: 'Admin Email',
                      controller: _emailController,
                      obscureText: false,
                    ),
                    const SizedBox(height: 20),
                    AuthWidgets.textField(
                      labelText: 'Admin Password',
                      controller: _passwordController,
                      obscureText: true,
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          // Add toggle password visibility if needed
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : AuthWidgets.primaryButton(
                            text: 'Admin Login',
                            onPressed: _adminLogin,
                          ),
                    const SizedBox(height: 10),
                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 10),
                    AuthWidgets.navigationLink(
                      isLogin: true,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      text: 'Go to User Login',
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// AuthRepository implementation with admin login
class AuthRepository {
  final http.Client httpClient;

  AuthRepository({required this.httpClient});

  Future<Map<String, dynamic>> adminLogin(String email, String password) async {
    final response = await httpClient.post(
      Uri.parse('https://api-tau-plum.vercel.app/api/adminLogin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    // Decode the response
    Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    
    // Assuming the API will return `isAdmin` along with success status
    return {
      'success': decodedResponse['success'],
      'message': decodedResponse['message'],
      'isAdmin': decodedResponse['isAdmin'],
    };
  }
}
