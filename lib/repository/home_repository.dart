import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job_model.dart';

class HomeRepository {
  final http.Client httpClient;
  final String baseUrl = 'https://api-tau-plum.vercel.app/api';

  HomeRepository({required this.httpClient});

  // Get the token from shared preferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Fetch all jobs for the home page
  Future<List<Job>> getAllJobs() async {
    final token = await _getToken();
    final response = await httpClient.get(
      Uri.parse('$baseUrl/jobs'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((job) => Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  // Fetch jobs with filters for home (like location, category)
  Future<List<Job>> getFilteredJobs({String? location, String? category}) async {
    final token = await _getToken();
    String queryString = '';

    if (location != null) {
      queryString += 'location=$location&';
    }
    if (category != null) {
      queryString += 'category=$category&';
    }

    final response = await httpClient.get(
      Uri.parse('$baseUrl/jobs?$queryString'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((job) => Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load filtered jobs');
    }
  }

  // Fetch recent jobs for the home page
  Future<List<Job>> getRecentJobs() async {
    final token = await _getToken();
    final response = await httpClient.get(
      Uri.parse('$baseUrl/jobs/recent'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((job) => Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load recent jobs');
    }
  }
}
