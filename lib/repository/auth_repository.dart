import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final http.Client httpClient;

  AuthRepository({required this.httpClient});

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    String? walletAddress, // Optional
    required String location,
    required String contact,
    required String profession,
    required String addinfo,
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
        'addinfo': addinfo,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Registration failed.');
    }
  }

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
      return json.decode(response.body)['token'];
    } else {
      throw Exception('Login failed.');
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}