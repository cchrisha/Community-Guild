import 'package:http/http.dart' as http;
import 'dart:convert';

class JobRepository {
  final String apiUrl = 'http://your-nodejs-api-url/jobs';

  Future<List<dynamic>> fetchJobs() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load jobs');
    }
  }
}
