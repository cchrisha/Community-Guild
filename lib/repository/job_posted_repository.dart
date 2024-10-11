import '../models/job_posted_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class JobRepository {
  final String apiUrl =
      "https://api.example.com/jobs"; // Replace with actual API URL

  Future<List<Job>> fetchJobs() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((job) => Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }
}
