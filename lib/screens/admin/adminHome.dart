import 'package:community_guild/screens/admin/admin_dashboard.dart';
import 'package:community_guild/screens/admin/admin_usersTrans.dart';
import 'package:community_guild/screens/admin/admin_settings.dart'; // Import the new settings page
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'admin_users.dart'; // Ensure this path is correct

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _currentIndex = 0;
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
      final response = await http
          .get(Uri.parse('https://api-tau-plum.vercel.app/api/users'));

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

  // Pages for each section
  final List<Widget> _pages = [
    // AdminDashboard(), // Dashboard page
    const AdminUserPage(), // Users page
    const UserTransactionPage(), // User transactions page
    AdminSettingsPage(), // Settings page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
      ),
      body: _pages[_currentIndex], // Display the current page based on index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected index
          });
        },
        items: const [
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.dashboard),
          //   label: 'Dashboard',
          // ),
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
      ),
    );
  }
}
