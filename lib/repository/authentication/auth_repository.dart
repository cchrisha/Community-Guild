import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final http.Client httpClient;

  AuthRepository({required this.httpClient});

  Future<void> registerUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    String? walletAddress, // Optional
    required String location,
    required String contact,
    required String profession,
  }) async {
    final response = await httpClient.post(
      Uri.parse('https://api-tau-plum.vercel.app/api/userSignup'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'walletAddress': walletAddress, // Optional field
        'location': location,
        'contact': contact,
        'profession': profession,
      }),
    );

    if (response.statusCode == 409) {
      throw Exception('Email already exists');
    } else if (response.statusCode != 201) {
      throw Exception('Registration failed');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Future<String> loginUser(String email, String password) async {
  //   final response = await httpClient.post(
  //     Uri.parse('https://api-tau-plum.vercel.app/api/userLogin'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode({
  //       'email': email,
  //       'password': password,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     final responseData = json.decode(response.body);
  //     final token = responseData['token'];

  //     if (responseData['success'] == true) {
  //       if (token == null || token.isEmpty) {
  //         throw Exception('Login failed: Token is null or empty.');
  //       }
  //       await saveToken(token); // Function to save token locally
  //       print('Token saved: $token');
  //       return token;
  //     } else {
  //       // Handle case when API response indicates failure despite 200 status
  //       throw Exception('Login failed: ${responseData['message']}');
  //     }
  //   } else {
  //     // Decode error response and throw with message
  //     final errorData = json.decode(response.body);
  //     final errorMessage = errorData['message'] ?? 'Login failed: Unknown error.';
  //     throw Exception(errorMessage);
  //   }
  // }

  Future<String> loginUser(String email, String password) async {
    final response = await httpClient.post(
        Uri.parse('https://api-tau-plum.vercel.app/api/userLogin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
            'email': email,
            'password': password,
        }),
    );

    if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        final userId = responseData['_id']; // Extracting user ID from the response

        if (responseData['success'] == true) {
            if (token == null || token.isEmpty) {
                throw Exception('Login failed: Token is null or empty.');
            }
            await saveToken(token); // Save token locally

            // Save user ID and name in SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('user_id', userId); // Save user ID
            await prefs.setString('user_name', responseData['name']); // Save the user's name

            print('Token saved: $token');
            print('User ID saved: $userId'); // Log user ID saving
            print('User name saved: ${responseData['name']}'); // Log user name saving
            return token;
        } else {
            // Handle case when API response indicates failure despite 200 status
            throw Exception('Login failed: ${responseData['message']}');
        }
    } else {
        // Decode error response and throw with message
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Login failed: Unknown error.';
        throw Exception(errorMessage);
    }
}

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    print('Token saved to SharedPreferences.'); //CHRISHA pang debug lang
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    //return prefs.getString('auth_token');
    final token = prefs.getString('auth_token'); //itooo din
    if (token == null || token.isEmpty) {
      print('No token found in SharedPreferences.');
    } else {
      print('Token retrieved from SharedPreferences: $token');
    }
    return token;
  }

  // NEW: Method to retrieve userId from the token
  Future<String?> getUserId() async {
    String? token = await getToken();
    if (token != null) {
      // Decode the token to get the userId (assuming it's a JWT)
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['userId'] as String?; // Ensure 'userId' is the correct field
    }
    return null; // Return null if token is not found or decoding fails
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    print('Token cleared from SharedPreferences.'); //tas itoo
  }
}
