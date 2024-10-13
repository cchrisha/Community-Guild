import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminUserPage extends StatefulWidget {
  const AdminUserPage({super.key});

  @override
  State<AdminUserPage> createState() => _AdminUserPageState();
}

class _AdminUserPageState extends State<AdminUserPage> {
  List<dynamic> _users = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final response = await http
          .get(Uri.parse('https://api-tau-plum.vercel.app/api/users'));

      if (response.statusCode == 200) {
        setState(() {
          _users = json.decode(response.body);
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

  Future<void> _updateVerifyStatus(String userId, bool isVerified) async {
    final url =
        'https://api-tau-plum.vercel.app/api/users/verify/$userId'; // Adjust as needed

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'isVerify': isVerified ? 1 : 0}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verify status updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update verify status')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _deleteUser(String userId) async {
    final url =
        'https://api-tau-plum.vercel.app/api/users/$userId'; // Delete endpoint

    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _users.removeWhere(
              (user) => user['_id'] == userId); // Remove user locally
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User deleted successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete user')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _showDeleteConfirmationDialog(String userId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteUser(userId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Management'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : SingleChildScrollView(
                  scrollDirection:
                      Axis.horizontal, // Enable horizontal scrolling
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('No.')),
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Location')),
                        DataColumn(label: Text('Profession')),
                        DataColumn(label: Text('Profile Picture')),
                        DataColumn(label: Text('Is Admin')),
                        DataColumn(label: Text('Is Verify')), // Editable
                        DataColumn(label: Text('Actions')), // For Delete
                      ],
                      rows: _users.asMap().entries.map<DataRow>((entry) {
                        int index = entry.key;
                        var user = entry.value;
                        bool isVerified = user['isVerify'] == 1;

                        return DataRow(
                          cells: [
                            DataCell(
                                Text((index + 1).toString())), // Row number
                            DataCell(Text(user['_id'])),
                            DataCell(Text(user['name'])),
                            DataCell(Text(user['email'])),
                            DataCell(Text(user['location'])),
                            DataCell(Text(user['profession'])),
                            DataCell(
                              user['profilePicture'] != null
                                  ? Image.network(user['profilePicture'],
                                      width: 50, height: 50)
                                  : const Icon(Icons.image_not_supported,
                                      size: 50),
                            ),
                            DataCell(Text(user['isAdmin'] == 1 ? 'Yes' : 'No')),
                            DataCell(
                              Switch(
                                value: isVerified,
                                onChanged: (bool newValue) {
                                  setState(() {
                                    _updateVerifyStatus(user['_id'], newValue);
                                    user['isVerify'] = newValue ? 1 : 0;
                                  });
                                },
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(
                                      user['_id']); // Delete user
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
    );
  }
}
