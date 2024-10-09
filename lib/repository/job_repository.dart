import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job_model.dart';

class JobRepository {
  final http.Client httpClient;
  final String baseUrl = 'https://api-tau-plum.vercel.app/api';

  JobRepository({required this.httpClient});

  // Get the token from shared preferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Fetch all jobs
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

  // Fetch jobs by profession
  Future<List<Job>> getJobsByProfession(String profession) async {
    final token = await _getToken();
    final response = await httpClient.get(
      Uri.parse('$baseUrl/jobs?profession=$profession'),
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

  // Post a new job
  Future<Job> createJob(Job job) async {
  final token = await _getToken();
  final response = await httpClient.post(
    Uri.parse('$baseUrl/jobs'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(job.toJson()),
  );

  if (response.statusCode == 201) {
    return Job.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to post job: ${response.statusCode} - ${response.body}');
  }
}

  // Update an existing job
  Future<Job> updateJob(Job job) async {
    final token = await _getToken();
    final response = await httpClient.put(
      Uri.parse('$baseUrl/jobs/${job.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(job.toJson()),
    );

    if (response.statusCode == 200) {
      return Job.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update job');
    }
  }

  // Delete a job
  Future<void> deleteJob(String jobId) async {
    final token = await _getToken();
    final response = await httpClient.delete(
      Uri.parse('$baseUrl/jobs/$jobId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete job');
    }
  }

  // Fetch jobs by recency or matching profession
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

  // Fetch jobs with filters (e.g., location, category)
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
}