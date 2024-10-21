import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:community_guild/models/job_home_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeRepository {
  final http.Client httpClient;

  HomeRepository({required this.httpClient});

  // Public method to retrieve the auth token
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      print('No token found');
      return null; // Return null if no token is found
    }
    print('Token retrieved: $token');
    return token;
  }

  Future<List<Job>> getRecommendedJobs() async {
    try {
      final token = await getAuthToken(); // Retrieve the token
      if (token == null) {
        throw Exception('No token available.');
      }

      final response = await httpClient.get(
        Uri.parse(
            'https://api-tau-plum.vercel.app/api/jobs/profession'), // Corrected endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer $token', // Send token in Authorization header
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jobsJson = jsonDecode(response.body);
        print('Recommended jobs response: $jobsJson');

        // Handle potential null values in the response
        return jobsJson.map((job) {
          if (job != null) {
            return Job.fromJson(job);
          } else {
            throw Exception('Job data is null');
          }
        }).toList();
      } else {
        throw Exception(
            'Failed to load recommended jobs. Status code: ${response.statusCode}, Response: ${response.body}');
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
        print('Most recent jobs response: $jobsJson');

        return jobsJson.map((job) {
          if (job != null) {
            return Job.fromJson(job);
          } else {
            throw Exception('Job data is null');
          }
        }).toList();
      } else {
        throw Exception(
            'Failed to load recent jobs. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Error loading recent jobs: $e');
      rethrow; // Re-throw the error for handling elsewhere
    }
  }

  Future<List<Job>> getAllJobs() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api-tau-plum.vercel.app/api/jobs/search?query=developer'));

      if (response.statusCode == 200) {
        // Parse the JSON data
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((job) => Job.fromJson(job)).toList();
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (e) {
      throw Exception('Error fetching jobs: $e');
    }
  }
}
