import 'package:community_guild/screens/admin/adminHome.dart';
import 'package:community_guild/screens/choose.dart';
import 'package:community_guild/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

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
      final token = data['token'];
      final isAdmin = data['isAdmin']; // Assuming isAdmin is included in the API response

      if (data['success'] == true) {
        if (token == null || token.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed: Token is null or empty.')),
          );
          return;
        }

        await saveToken(token); // Save token locally
        print('Token saved: $token');

        // Verify if the user is indeed an admin
        if (isAdmin == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Admin login successful!"),
                backgroundColor: Colors.green),
          );

          // Navigate to Admin Home Page after a short delay
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminHomePage()),
            );
          });
        } 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login failed. Please check your credentials.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${response.reasonPhrase}")),
      );
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token); // Store token under 'auth_token'
    print('Token saved to SharedPreferences.'); // Debug message
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome Admin!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 30),
                
                // Email TextField with padding and focus border transition 
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  height: 55,
                  width: double.infinity,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Admin Email',
                      labelStyle: GoogleFonts.poppins(color: Colors.black),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color.fromARGB(255, 190, 190, 190), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 1), // Focused border
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Password TextField with padding and focus border transition
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  height: 55,
                  width: double.infinity,
                  child: TextField(
                    controller: passwordController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      labelText: 'Admin Password',
                      labelStyle: GoogleFonts.poppins(color: const Color.fromARGB(255, 0, 0, 0)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      suffixIcon: IconButton(
                        icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color.fromARGB(255, 190, 190, 190), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Login button
                Container(
                  height: 55,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.lightBlue,
                    ),
                    child: const Text(
                      'Admin Login', 
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
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
