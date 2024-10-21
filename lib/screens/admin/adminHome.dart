import 'package:community_guild/screens/admin/admin_dashboard.dart';
import 'package:community_guild/screens/admin/admin_usersTrans.dart';
import 'package:community_guild/screens/admin/admin_settings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'admin_users.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _currentIndex = 0;
  int _totalUsers = 0;
  int _completedTransactions = 0; // Track completed transactions
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCounts(); // Fetch both user and transaction counts
  }

  Future<void> _fetchCounts() async {
    try {
      // Fetch total users
      final userResponse = await http
          .get(Uri.parse('https://api-tau-plum.vercel.app/api/userGetTransac'));
      if (userResponse.statusCode == 200) {
        final List<dynamic> users = json.decode(userResponse.body);
        _totalUsers = users.length;
      } else {
        _errorMessage = 'Failed to load user count';
      }

      // Fetch total completed transactions
      final transactionResponse = await http.get(Uri.parse(
          'https://api-tau-plum.vercel.app/api/transactions')); // Adjust the URL
      if (transactionResponse.statusCode == 200) {
        final List<dynamic> transactions =
            json.decode(transactionResponse.body);
        _completedTransactions = transactions
            .where((transaction) => transaction['status'] == 'completed')
            .length; // Filter for completed transactions
      } else {
        _errorMessage = 'Failed to load transaction count';
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  // Pages for each section
  final List<Widget> _pages = [];

  @override
  Widget build(BuildContext context) {
    // Ensure the dashboard is updated with the fetched data
    _pages.clear();
    _pages.add(
      AdminDashboard(
        totalUsers: _totalUsers,
        completedTransactions: _completedTransactions,
      ),
    );
    _pages.add(AdminUserPage());
    _pages.add(UserTransactionPage());
    _pages.add(AdminSettingsPage());

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pages[_currentIndex], // Display the current page based on index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected index
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
