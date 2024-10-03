import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileRepository {
  final String baseUrl;

  ProfileRepository({required this.baseUrl});

  // Fetch profile data
  Future<Map<String, dynamic>> fetchProfile() async {
    final response = await http.get(Uri.parse('$baseUrl/profile'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  // Verify account
  Future<void> verifyAccount() async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-account'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to verify account');
    }
  }
}
