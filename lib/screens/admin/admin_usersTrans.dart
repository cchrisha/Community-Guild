import 'package:community_guild/models/payment_model.dart';
import 'package:community_guild/screens/admin/admin_transactionDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserTransactionPage extends StatefulWidget {
  const UserTransactionPage({super.key});

  @override
  State<UserTransactionPage> createState() => _UserTransactionPageState();
}

class _UserTransactionPageState extends State<UserTransactionPage> {
  List<dynamic> _usersWithTransactions = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchUsersWithTransactions();
  }

  Future<void> _fetchUsersWithTransactions() async {
    try {
      final response = await http.get(Uri.parse('https://api-tau-plum.vercel.app/api/users'));

      if (response.statusCode == 200) {
        final List<dynamic> users = json.decode(response.body);
        List<dynamic> usersWithTransactions = [];

        for (var user in users) {
          var transactions = await fetchTransactions(user['walletAddress']);
          usersWithTransactions.add({
            'userId': user['_id'],
            'name': user['name'],
            'email': user['email'],
            'walletAddress': user['walletAddress'],
            'transactions': transactions,
          });
        }

        setState(() {
          _usersWithTransactions = usersWithTransactions;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load users';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<List<dynamic>> fetchTransactions(String? walletAddress) async {
    if (walletAddress == null || walletAddress.isEmpty) return [];

    const etherscanApiKey = '5KEE4GXQSGWAFCJ6CWBJPMQ5BV3VQ33IX1';
    final url = 'https://api-sepolia.etherscan.io/api?module=account&action=txlist&address=$walletAddress&startblock=0&endblock=99999999&sort=desc&apikey=$etherscanApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == '1') {
        return data['result'].map((tx) {
          final amount = (BigInt.parse(tx['value']) / BigInt.from(10).pow(18)).toString(); // Convert from Wei to ETH
          final date = DateTime.fromMillisecondsSinceEpoch(int.parse(tx['timeStamp']) * 1000).toLocal();
          final isSent = tx['from'].toLowerCase() == walletAddress.toLowerCase(); // Determine if it's sent or received

          return {
            'From': tx['from'],
            'To': tx['to'],
            'Amount': amount,
            'Date': date.toLocal().toString().split(' ')[0], // Only the date part
            'Time': date.toLocal().toString().split(' ')[1], // Only the time part
            'isSent': isSent,
          };
        }).toList();
      } else {
        print('Etherscan API error: ${data['message']}');
        return [];
      }
    } catch (error) {
      print('Error fetching transactions: $error');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Transactions'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                labelText: 'Search Users',
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : ListView.builder(
                          itemCount: _usersWithTransactions.length,
                          itemBuilder: (context, userIndex) {
                            var user = _usersWithTransactions[userIndex];
                            // Filter users based on the search query
                            if (!user['name'].toLowerCase().contains(_searchQuery) &&
                                !user['email'].toLowerCase().contains(_searchQuery)) {
                              return const SizedBox.shrink();
                            }

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: InkWell(
                                onTap: () {
                                  // Navigate to MyWidget with user data
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminTransactionDetails(user: user), // Pass user data here
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${user['name']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                      Text('Email: ${user['email']}', style: const TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
