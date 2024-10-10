import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:community_guild/models/job_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeRepository {
  final http.Client httpClient;

  HomeRepository({required this.httpClient});

  // Method to retrieve the auth token
  Future<String> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      throw Exception('No token found. Please login first.');
    }
    return token;
  }

  Future<List<Job>> getRecommendedJobs() async {
    try {
      final token = await _getAuthToken(); // Retrieve the token
      final response = await httpClient.get(
        Uri.parse('https://api-tau-plum.vercel.app/api/jobs/profession'), // Corrected endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',  // Send token in Authorization header
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jobsJson = jsonDecode(response.body);
        return jobsJson.map((job) => Job.fromJson(job)).toList();
      } else {
        throw Exception('Failed to load recommended jobs. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Error loading recommended jobs: $e');
      rethrow; // Re-throw the error for handling elsewhere
    }
  }

  Future<List<Job>> getMostRecentJobs() async {
    try {
      final response = await httpClient.get(
        Uri.parse('https://api-tau-plum.vercel.app/api/jobs/recent'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // No token added for most recent jobs
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jobsJson = jsonDecode(response.body);
        return jobsJson.map((job) => Job.fromJson(job)).toList();
      } else {
        throw Exception('Failed to load recent jobs. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Error loading recent jobs: $e');
      rethrow; // Re-throw the error for handling elsewhere
    }
  }
}
