import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePictureRepository {
  final String uploadApiUrl = 'https://api-tau-plum.vercel.app/api/uploadImage';
  final String fetchApiUrl =
      'https://api-tau-plum.vercel.app/api/profilePicture'; // Ensure this matches your backend

  Future<String> uploadProfilePicture(File profileImage) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception("No authentication token found");
      }

      var request = http.MultipartRequest('POST', Uri.parse(uploadApiUrl));
      request.headers['Authorization'] = 'Bearer $token';
      request.files
          .add(await http.MultipartFile.fromPath('image', profileImage.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        var data = json.decode(responseData.body);
        return data['imageUrl']; // URL of the uploaded image
      } else {
        throw Exception('Failed to upload profile picture');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<String> fetchProfilePicture() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception("No authentication token found");
      }

      final response = await http.get(Uri.parse(fetchApiUrl), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['profilePicture'] ??
            ''; 
      } else {
        throw Exception('Failed to fetch profile picture');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
