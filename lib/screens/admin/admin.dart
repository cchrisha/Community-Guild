import 'package:community_guild/screens/admin/adminHome.dart';
import 'package:community_guild/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  Future<void> _login() async {
    final email = emailController.text;
    final password = passwordController.text;

    // Make your API call for admin login
    final response = await http.post(
      Uri.parse('https://api-tau-plum.vercel.app/api/adminLogin'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      //final token = data['token'];
      final isAdmin = data['isAdmin']; // Make sure to include isAdmin in the API response

      // Store token and admin status in SharedPreferences
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      //await prefs.setString('auth_token', token);
      //await prefs.setInt('isAdmin', isAdmin);

      // Navigate to HomePage if admin
          if (isAdmin == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Admin login successful!"), backgroundColor: Colors.green),
          );
          // Navigate to Admin Home Page after a short delay
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminHomePage()), // Replace with your actual Admin Home page widget
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You're not an admin."), backgroundColor: Colors.red),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed. Please check your credentials.")),
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Welcome Admin!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                const SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Admin Email'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    labelText: 'Admin Password',
                    suffixIcon: IconButton(
                      icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Admin Login'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()), // Replace with your user login page
                    );
                  },
                  child: const Text('Go to User Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
