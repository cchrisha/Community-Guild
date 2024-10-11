import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordRepository {
  final String baseUrl = "https://api-tau-plum.vercel.app/api";

  Future<void> changePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs
        .getString('auth_token'); // Assuming the token is stored as 'authToken'

    if (token == null) {
      throw Exception("User not authenticated.");
    }

    // Create the API request payload
    final body = jsonEncode({
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    });

    final response = await http.put(
      Uri.parse('$baseUrl/changePassword'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      // Password changed successfully
      return;
    } else {
      // Handle error response from the API
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      throw Exception(responseData['message'] ?? 'Password change failed');
    }
  }
}
