import 'dart:convert';
import 'package:http/http.dart' as http;

class JobRepository {
  final String baseUrl = "http://localhost:3000/jobs";

  Future<Map<String, dynamic>> fetchJobDetail(int jobId) async {
    final response = await http.get(Uri.parse('$baseUrl/$jobId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load job details');
    }
  }
}
