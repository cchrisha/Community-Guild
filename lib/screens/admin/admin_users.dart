import 'package:community_guild/screens/admin/admin_userDetails.dart';
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
  String _searchQuery = "";
  String _filterValue = 'All Users';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final response =
          await http.get(Uri.parse('https://api-tau-plum.vercel.app/api/users'));

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
      print(e); // Debugging output
    }
  }

  Future<void> _deleteUser(String userId) async {
    final url = 'https://api-tau-plum.vercel.app/api/users/$userId';

    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _users.removeWhere((user) => user['_id'] == userId);
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('User deleted successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete user')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
      print(e); // Debugging output
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

  // Method to filter users based on creation time
  List<dynamic> _filterUsers() {
    DateTime now = DateTime.now();

    if (_filterValue == 'New Users') {
      return _users.where((user) {
        DateTime createdAt = DateTime.parse(user['createdAt']);
        return now.difference(createdAt).inDays <= 2; // Users created in the last 2 days
      }).toList();
    }
    
    // For "All Users", return all users
    return _users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Management'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.explore),
            onPressed: () {
              // Export logic here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
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
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _filterValue,
                  items: <String>['All Users', 'New Users']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _filterValue = newValue!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : ListView.builder(
                          itemCount: _filterUsers().length,
                          itemBuilder: (context, index) {
                            var user = _filterUsers()[index];
                            if (!user['name']
                                    .toLowerCase()
                                    .contains(_searchQuery) &&
                                !user['email']
                                    .toLowerCase()
                                    .contains(_searchQuery)) {
                              return const SizedBox.shrink();
                            }

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: user['profilePicture'] != null
                                      ? NetworkImage(user['profilePicture'])
                                      : const AssetImage('assets/default_profile.png'), // Default image
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${index + 1}. ${user['name']}'), // Number and Name
                                    PopupMenuButton<String>(
                                      onSelected: (String value) {
                                        if (value == 'delete') {
                                          _showDeleteConfirmationDialog(user['_id']);
                                        }
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return {
                                          'delete',
                                        }.map((String choice) {
                                          return PopupMenuItem<String>(
                                            value: choice,
                                            child: Text('Delete User'),
                                          );
                                        }).toList();
                                      },
                                    ),
                                  ],
                                ),
                                subtitle: Text(user['email']),
                                onTap: () {
                                  // Navigate to UserDetailsPage with user data
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminUserDetailsPage(
                                        
                                        
                                        user: user),
                            ),
                          );
                        },
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
