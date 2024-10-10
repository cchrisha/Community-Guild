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
      final token = json.decode(response.body)['token'];
      if (token == null || token.isEmpty) {  //CHRISHA add ko to
        throw Exception('Login failed: Token is null or empty.');
      }
      await saveToken(token);
      print('Token saved: $token');
      return token;
    } else {
      throw Exception('Login failed.');
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

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    print('Token cleared from SharedPreferences.'); //tas itoo
  }
}
