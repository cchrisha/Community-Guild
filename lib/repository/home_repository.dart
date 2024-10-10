import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:community_guild/models/job_model.dart';

class HomeRepository {
  final http.Client httpClient;

  HomeRepository({required this.httpClient});

  Future<List<Job>> getRecommendedJobs(String profession) async {
    final response = await httpClient.get(
      Uri.parse('https://api-tau-plum.vercel.app/api/jobs/profession?profession=$profession'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jobsJson = jsonDecode(response.body);
      return jobsJson.map((job) => Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load recommended jobs');
    }
  }

  Future<List<Job>> getMostRecentJobs() async {
    final response = await httpClient.get(
      Uri.parse('https://api-tau-plum.vercel.app/api/jobs/recent'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jobsJson = jsonDecode(response.body);
      return jobsJson.map((job) => Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load recent jobs');
    }
  }
}
