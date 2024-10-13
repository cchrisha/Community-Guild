import 'package:community_guild/screens/admin/admin_usersTrans.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'admin_users.dart'; // Make sure this path is correct

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _totalUsers = 0;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserCount();
  }

  Future<void> _fetchUserCount() async {
    try {
      final response = await http.get(Uri.parse('https://api-tau-plum.vercel.app/api/users'));

      if (response.statusCode == 200) {
        final List<dynamic> users = json.decode(response.body);
        setState(() {
          _totalUsers = users.length;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load user count';
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
        title: const Text('Admin Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            Card(
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminUserPage()), // Navigate to AdminUserPage
                  );
                },
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.group, size: 60, color: Colors.blue),
                      const SizedBox(height: 10),
                      _isLoading
                      ? const CircularProgressIndicator() // Loading indicator while fetching user count
                      : Text(
                          'Users (${_totalUsers})', // Display total user count
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 4,
              child: InkWell(
                onTap: () {
                   Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => const UserTransactionPage()), // Navigate to Transaction Management page
                 );
                },
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.attach_money, size: 60, color: Colors.green),
                      SizedBox(height: 10),
                      Text(
                        'Users Transactions',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 4,
              child: InkWell(
                onTap: () {
                  // Navigator.push(
                 //   context,
                  //  MaterialPageRoute(builder: (context) => UserTransactionPage()), // Navigate to Transaction Management page
                 //);
                },
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.attach_money, size: 60, color: Colors.green),
                      SizedBox(height: 10),
                      Text(
                        'Settings',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
