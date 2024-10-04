import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LogoutRepository {
  final String apiUrl = 'https://api-tau-plum.vercel.app/api/logout';

  Future<void> logout(String token) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      print('Token cleared from SharedPreferences');
    } else {
      final errorMessage = json.decode(response.body)['message'];
      throw Exception(errorMessage ?? 'Logout failed. Please try again.');
    }
  }
}
