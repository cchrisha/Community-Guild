import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/logout/bloc/logout_bloc.dart';
import '../bloc/logout/bloc/logout_event.dart';
import '../bloc/logout/bloc/logout_state.dart';
import '../widget/settings/section_header.dart';
import '../widget/settings/settings_app_bar.dart';
import '../widget/settings/settings_tile.dart';
import '../widget/settings/switch_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogoutBloc(),
      child: Scaffold(
        appBar: SettingsAppBar(onBackPressed: () {
          Navigator.pop(context);
        }),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SectionHeader(title: 'Account Settings'),
            SettingsTile(
              icon: Icons.lock,
              title: 'Change Password',
              onTap: () {
                // Navigate to change password page
              },
            ),
            SettingsTile(
              icon: Icons.link,
              title: 'Manage Linked Accounts',
              onTap: () {
                // Navigate to manage accounts page
              },
            ),
            const SectionHeader(title: 'Notifications'),
            SwitchTile(
              icon: Icons.notifications,
              title: 'Push Notifications',
              value: true,
              onChanged: (value) {
                // Handle switch toggle
              },
            ),
            const SectionHeader(title: 'Privacy'),
            SettingsTile(
              icon: Icons.lock_outline,
              title: 'Privacy Settings',
              onTap: () {
                // Navigate to privacy settings page
              },
            ),
            const SectionHeader(title: 'App Info'),
            SettingsTile(
              icon: Icons.info_outline,
              title: 'About the App',
              onTap: () {
                // Navigate to app info page
              },
            ),
            SettingsTile(
              icon: Icons.logout_outlined,
              title: 'Log out',
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<LogoutBloc, LogoutState>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              Navigator.of(context).pop(); // Close dialog on success
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            }
            if (state is LogoutFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is LogoutLoading) {
              return const AlertDialog(
                title: Text('Logging out...'),
                content: SizedBox(
                  height: 50,
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            } else {
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
                    onPressed: () {
                      context.read<LogoutBloc>().add(LogoutRequested());
                    },
                    child: const Text('Logout'),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }
}
