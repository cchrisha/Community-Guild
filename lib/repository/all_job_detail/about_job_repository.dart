import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:community_guild/models/about_job_model.dart';
//import 'package:community_guild/repositories/auth_repository.dart';
import 'package:community_guild/repository/authentication/auth_repository.dart';

class AboutJobRepository {
  final String baseUrl = 'https://api-tau-plum.vercel.app/api/user/jobs/status/';
  final AuthRepository authRepository; // Add AuthRepository to constructor

  AboutJobRepository({required this.authRepository}); // Accept it via constructor

  Future<List<AboutJobModel>> fetchJobsByStatus(String status) async {
    try {
      // Retrieve the token from AuthRepository
      String? token = await authRepository.getToken();
      
      // Check if the token is null or empty
      if (token == null || token.isEmpty) {
        throw Exception('No valid token found. Please login again.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl$status'),
        headers: {
          'Authorization': 'Bearer $token', // Use the retrieved token
          'Content-Type': 'application/json',
        },
      );

      print('Status code: ${response.statusCode}'); // Debugging response status
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => AboutJobModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load jobs with status: $status. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchJobsByStatus: $e'); // Error logging
      throw Exception('Error: $e');
    }
  }

  // New method for fetching jobs posted by the user
  Future<List<AboutJobModel>> fetchJobsPostedByUser(String userId) async {
  try {
    String? token = await authRepository.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No valid token found. Please login again.');
    }

    // Correctly construct the URL with userId
    final response = await http.get(
      Uri.parse('https://api-tau-plum.vercel.app/api/user/$userId/jobs'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => AboutJobModel.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      print('Failed to load jobs: ${response.body}');
      throw Exception('No jobs found for this user.');
    } else {
      throw Exception(
          'Failed to load posted jobs. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in fetchJobsPostedByUser: $e');
    throw Exception('Error: $e');
  }
}

  // New method for fetching applicants for a specific job
  Future<List<String>> fetchJobApplicants(String jobId) async {
    try {
      String? token = await authRepository.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('No valid token found. Please login again.');
      }

      final response = await http.get(
        Uri.parse('https://api-tau-plum.vercel.app/api/jobs/$jobId/requests'), // Replace with your API endpoint
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        // Assuming the response contains a list of requests, each with a user object containing a name
        return jsonData.map((request) => request['user']['name'] as String).toList();
      } else {
        throw Exception('Failed to load applicants. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchJobApplicants: $e');
      throw Exception('Error: $e');
    }
  }

  // New method for fetching workers for a specific job
Future<List<String>> fetchJobWorkers(String jobId) async {
  try {
    String? token = await authRepository.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No valid token found. Please login again.');
    }

    final response = await http.get(
      Uri.parse('https://api-tau-plum.vercel.app/api/jobs/$jobId/workers'), // Replace with your API endpoint
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      // Assuming each worker has a user object with a 'name'
      return jsonData.map((worker) => worker['user']['name'] as String).toList();
    } else {
      throw Exception('Failed to load workers. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in fetchJobWorkers: $e');
    throw Exception('Error: $e');
  }
}

}




