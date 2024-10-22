import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  final String baseUrl = 'https://api-tau-plum.vercel.app/api';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, dynamic>> fetchProfile() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  // Verify account
  Future<void> verifyAccount() async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-account'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to verify account');
    }
  }

  Future<void> updateUserProfile({
    required String name,
    required String location,
    required String contact,
    required String profession,
  }) async {
    final token = await getToken();

    if (token == null) {
      throw Exception('Authentication token not found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/updateUserProfile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'location': location,
        'contact': contact,
        'profession': profession,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }

  Future<String> uploadProfilePicture(File profileImage) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception("No authentication token found");
      }

      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/uploadImage'));
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

      final response = await http.get(Uri.parse('$baseUrl/profilePicture'), headers: {
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

  Future<String> fetchotherProfilePicture({required String userId}) async {
  try {
    // Fetch the token from SharedPreferences
    final String? token = await getToken();
    if (token == null) {
      print('No token found');
      return '';
    }

    print('Fetching profile picture for user ID: $userId with token: $token'); // Debug userId and token

    final response = await http.get(
      Uri.parse('https://api-tau-plum.vercel.app/api/users/$userId/profilePicture'),
      headers: {
        'Authorization': 'Bearer $token', // Include the token in the headers
      },
    );

    // Log the response for debugging
    print('Profile Picture API Response (status: ${response.statusCode}): ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['data']['profilePictureUrl'] ?? ''; // Adjust according to your API response
    } else {
      // Log the response body when the request fails
      print('Failed to fetch profile picture. Status Code: ${response.statusCode}, Response: ${response.body}');
      return ''; // Return empty if fetch fails
    }
  } catch (e) {
    // Catch and log any exceptions that occur
    print('Exception occurred while fetching profile picture: $e');
    return ''; // Handle exceptions
  }
}

Future<void> sendVerificationRequest() async {
  final token = await getToken(); // Fetch the token

  if (token == null) {
    throw Exception('Authentication token not found');
  }

  final response = await http.post(
    Uri.parse('https://api-tau-plum.vercel.app/api/notifications/request-verification'), // Your actual API endpoint
    headers: {
      'Content-Type': 'application/json',
      'auth_token': token, // Use auth_token here
    },
    body: json.encode({
      // If there are any parameters to send, include them here
    }),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to send verification request: ${response.body}');
  }
}

}
