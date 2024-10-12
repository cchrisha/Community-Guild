import 'package:community_guild/models/about_job_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AboutJobRepository {
  final String baseUrl = 'https://api-tau-plum.vercel.app/api/user/jobs/status/';

  Future<List<AboutJobModel>> fetchJobsByStatus(String status) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$status'),
        headers: {
          'Authorization': 'Bearer your_token_here', // Ensure valid token
          'Content-Type': 'application/json',
        },
      );

      print('Status code: ${response.statusCode}');
      print('Response request URL: ${response.request?.url}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          List<dynamic> jsonData = json.decode(response.body);
          return jsonData.map((json) => AboutJobModel.fromJson(json)).toList();
        } catch (jsonError) {
          print('JSON decoding error: $jsonError');
          throw Exception('Invalid JSON format');
        }
      } else {
        throw Exception('Failed to load jobs with status: $status');
      }
    } catch (e) {
      print('Error in fetchJobsByStatus: $e');
      throw Exception('Error: $e');
    }
  }
}
