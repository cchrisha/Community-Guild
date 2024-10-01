import 'package:community_guild/models/userAuth_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  final http.Client httpClient;

  UserService({required this.httpClient});

  Future<Userauth?> fetchUserProfile(String userId) async {
    final response = await httpClient.get(
      Uri.parse('https://api-tau-plum.vercel.app/api/user/$userId'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Userauth.fromJson(json);
    } else {
      throw Exception('Failed to load user profile');
    }
  }
}
