// lib/services/job_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/current_job_model.dart';

class CurrentJobRepository {
  final String baseUrl;

  CurrentJobRepository({required this.baseUrl});

  Future<List<Job>> fetchJobs(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Job.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }
}
