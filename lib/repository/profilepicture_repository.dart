import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
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

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers['Authorization'] = 'Bearer $token';

      // Convert the image file to a base64 string
      List<int> imageBytes = await profileImage.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Send the base64 string to your backend
      request.fields['profilePicture'] = base64Image;

      var response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        var data = json.decode(responseData.body);
        return data['profilePicture']; // URL of the uploaded image
      } else {
        throw Exception('Failed to upload profile picture');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
