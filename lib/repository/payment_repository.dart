// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/payment_model.dart';

// class PaymentProvider with ChangeNotifier {
//   String walletAddress = '';
//   String balance = '0';
//   bool isConnected = false;
//   bool isLoading = false;
//   List<TransactionDetails> transactions = [];

//   Future<void> initializeWallet() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     walletAddress = prefs.getString('walletAddress') ?? '';
//     notifyListeners();
//   }

//   Future<void> connectWallet() async {
//     // MetaMask connection logic
//     walletAddress = 'new_wallet_address'; // Example wallet address
//     isConnected = true;
//     notifyListeners();
//     fetchTransactions(walletAddress);
//   }

//   void disconnectWallet() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('walletAddress');
//     walletAddress = '';
//     balance = '0';
//     isConnected = false;
//     transactions.clear();
//     notifyListeners();
//   }

//   Future<void> fetchTransactions(String address) async {
//     isLoading = true;
//     notifyListeners();
//     try {
//       final url =
//           'https://api-sepolia.etherscan.io/api?module=account&action=txlist&address=$address&apikey=YOUR_API_KEY';
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == '1') {
//           final txList = data['result'] as List;
//           transactions = txList.map((tx) {
//             return TransactionDetails.fromMap(tx);
//           }).toList();
//         }
//       }
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
// }
