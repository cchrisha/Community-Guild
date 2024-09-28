import 'package:community_guild/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader('Account Settings'),
          _buildSettingsTile(
            icon: Icons.lock,
            title: 'Change Password',
            onTap: () {
              // Navigate to change password page
            },
          ),
          _buildSettingsTile(
            icon: Icons.link,
            title: 'Manage Linked Accounts',
            onTap: () {
              // Navigate to manage accounts page
            },
          ),
          _buildSectionHeader('Notifications'),
          _buildSwitchTile(
            icon: Icons.notifications,
            title: 'Push Notifications',
            value: true, // Current state
            onChanged: (value) {
              // Handle switch toggle
            },
          ),
          _buildSwitchTile(
            icon: Icons.email,
            title: 'Email Notifications',
            value: false, // Current state
            onChanged: (value) {
              // Handle switch toggle
            },
          ),
          _buildSectionHeader('Privacy'),
          _buildSettingsTile(
            icon: Icons.lock_outline,
            title: 'Privacy Settings',
            onTap: () {
              // Navigate to privacy settings page
            },
          ),
          _buildSectionHeader('App Info'),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: 'About the App',
            onTap: () {
              // Navigate to app info page
            },
          ),
          _buildSettingsTile(
            icon: Icons.logout_outlined,
            title: 'Log out',
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.lightBlue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title),
      secondary: Icon(icon, color: Colors.lightBlue),
    );
  }
}
