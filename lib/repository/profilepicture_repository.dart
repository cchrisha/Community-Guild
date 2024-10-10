import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePictureRepository {
  final String apiUrl =
      'https://api-tau-plum.vercel.app/api/uploadProfilePicture';

  Future<String> uploadProfilePicture(File profileImage) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception("No authentication token found");
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(apiUrl),
      );

      request.headers['Authorization'] = 'Bearer $token';

      var mimeType =
          lookupMimeType(profileImage.path)!.split('/'); // Get the file type
      request.files.add(
        await http.MultipartFile.fromPath(
          'profilePicture',
          profileImage.path,
          contentType: MediaType(mimeType[0], mimeType[1]),
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        var data = json.decode(responseData.body);
        return data['profilePicture']; // Returns the profile picture URL
      } else {
        throw Exception('Failed to upload profile picture');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
