import 'dart:convert';
import 'package:http/http.dart' as http;

class JobRepository {
  final String baseUrl = "https://api-tau-plum.vercel.app/api/jobs"; // Updated to match your API

  // Fetch job details
  // Future<Map<String, dynamic>> fetchJobDetail(int jobId) async {
  //   final response = await http.get(Uri.parse('$baseUrl/$jobId'));

  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception('Failed to load job details');
  //   }
  // }

  // Post a new job
  Future<void> postJob({
    required String title,
    required String wageRange,
    required bool isCrypto,
    required String location,
    required String professions,
    required String categories,
    required String description,
    required String token,
  }) async {
    final url = Uri.parse(baseUrl);

    // Prepare the job data
    final body = json.encode({
      'title': title,
      'wageRange': wageRange,
      'isCrypto': isCrypto,
      'location': location,
      'professions': professions,
      'categories': categories,
      'description': description,
    });

    // Set headers, including the authorization token
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // Make the POST request
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 201) {
      // If the response code is not 201 (Created), throw an error
      throw Exception('Failed to post job: ${response.body}');
    }
  }
}
