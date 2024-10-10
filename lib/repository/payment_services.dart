// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class AuthService {
//   static Future<void> loginWithMetaMask(
//       String email, String password, String walletAddress) async {
//     final response = await http.post(
//       Uri.parse('https://api.example.com/api/userLogin'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'email': email,
//         'password': password,
//         'walletAddress': walletAddress,
//       }),
//     );
//     if (response.statusCode == 200) {
//       // Handle success
//     }
//   }

//   static Future<void> logout() async {
//     final response = await http.post(
//       Uri.parse('https://api.example.com/api/logout'),
//       headers: {'Content-Type': 'application/json'},
//     );
//     if (response.statusCode == 200) {
//       // Handle success
//     }
//   }
// }
