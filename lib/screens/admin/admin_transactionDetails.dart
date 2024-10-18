import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminTransactionDetails extends StatefulWidget {
  final Map<String, dynamic> user; // Accept user data

  const AdminTransactionDetails({super.key, required this.user}); // Use required keyword for non-nullable parameter

  @override
  State<AdminTransactionDetails> createState() => _AdminTransactionDetailsState();
}

class _AdminTransactionDetailsState extends State<AdminTransactionDetails> {
  List<dynamic> _transactions = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTransactions(); // Fetch transactions when the widget is initialized
  }

  Future<void> _fetchTransactions() async {
    String walletAddress = widget.user['walletAddress'];
    const etherscanApiKey = '5KEE4GXQSGWAFCJ6CWBJPMQ5BV3VQ33IX1'; // Replace with your actual API key
    final url = 'https://api-sepolia.etherscan.io/api?module=account&action=txlist&address=$walletAddress&startblock=0&endblock=99999999&sort=desc&apikey=$etherscanApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == '1') {
        setState(() {
          _transactions = data['result'].map((tx) {
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
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load transactions: ${data['message']}';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user['name']), // Display user's name in the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${widget.user['email']}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Wallet Address: ${widget.user['walletAddress']}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text('Transactions:', style: TextStyle(fontWeight: FontWeight.bold)),

            // Show loading indicator or error message if applicable
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(child: Text(_errorMessage!))
                    : Expanded(
                        child: _transactions.isEmpty
                            ? const Center(child: Text('No transactions available'))
                            : ListView.builder(
                                itemCount: _transactions.length,
                                itemBuilder: (context, index) {
                                  var tx = _transactions[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('From: ${tx['From']}'),
                                          Text('To: ${tx['To']}'),
                                          Text('Amount: ${tx['Amount']} ETH'),
                                          Text('Date: ${tx['Date']}'),
                                          Text('Time: ${tx['Time']}'),
                                          Text(tx['isSent'] ? 'Status: Sent' : 'Status: Received',
                                              style: TextStyle(color: tx['isSent'] ? Colors.red : Colors.green)),
                                        ],
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
