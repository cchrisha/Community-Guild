import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgetPasswordRepository {
  final String baseUrl = "https://api-tau-plum.vercel.app/api";

  Future<String> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgotPassword'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else {
        throw Exception(
            jsonDecode(response.body)['error'] ?? 'Failed to send OTP');
      }
    } catch (error) {
      throw Exception('Network error occurred: ${error.toString()}');
    }
  }

  Future<String> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verifyOtp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else {
        throw Exception(
            jsonDecode(response.body)['error'] ?? 'Failed to verify OTP');
      }
    } catch (error) {
      throw Exception('Network error occurred: ${error.toString()}');
    }
  }

  Future<String> resetPassword(String email, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/resetPassword'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else {
        throw Exception(
            jsonDecode(response.body)['error'] ?? 'Failed to reset password');
      }
    } catch (error) {
      throw Exception('Network error occurred: ${error.toString()}');
    }
  }
}
