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
          final amount = (BigInt.parse(tx['value']) / BigInt.from(10).pow(18)).toString();// Convert from Wei to ETH
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('No.')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('From')),
                      DataColumn(label: Text('To')),
                      DataColumn(label: Text('Amount (ETH)')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Time')),
                      DataColumn(label: Text('Type')), // New column for Sent/Received
                    ],
                    rows: _usersWithTransactions.expand<DataRow>((user) {
                      return user['transactions'].map<DataRow>((tx) {
                        return DataRow(
                          cells: [
                            DataCell(Text('${_usersWithTransactions.indexOf(user) + 1}')),
                            DataCell(Text(user['name'])),
                            DataCell(Text(user['email'])),
                            DataCell(Text(tx['From'])),
                            DataCell(Text(tx['To'])),
                            DataCell(Text(tx['Amount'])),
                            DataCell(Text(tx['Date'])),
                            DataCell(Text(tx['Time'])),
                            DataCell(Text(tx['isSent'] ? 'Sent' : 'Received')), // Determine sent or received
                          ],
                        );
                      });
                    }).toList(),
                  ),
                ),
    );
  }
}
