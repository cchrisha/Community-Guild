import 'package:community_guild/bloc/logout/bloc/logout_event.dart';
import 'package:community_guild/bloc/logout/bloc/logout_state.dart';
import 'package:community_guild/repository/logout_repository.dart';
import 'package:community_guild/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../bloc/logout/bloc/logout_bloc.dart';
import '../widget/settings/section_header.dart';
import '../widget/settings/settings_app_bar.dart';
import '../widget/settings/settings_tile.dart';
import 'about_app.dart';
import 'change_password.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogoutBloc(LogoutRepository()),
      child: BlocConsumer<LogoutBloc, LogoutState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Get.offAll(() => const LoginPage());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Logged out successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is LogoutFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: SettingsAppBar(onBackPressed: () {
              Navigator.pop(context);
            }),
            body: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    const SectionHeader(title: 'Account Settings'),
                    SettingsTile(
                      icon: Icons.lock,
                      title: 'Change Password',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChangePasswordPage()),
                        );
                      },
                    ),
                    const SectionHeader(title: 'App Info'),
                    SettingsTile(
                      icon: Icons.info_outline,
                      title: 'About the App',
                      onTap: () {
                        // Navigate to AboutAppPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AboutAppPage()),
                        );
                      },
                    ),
                    SettingsTile(
                      icon: Icons.logout_outlined,
                      title: 'Log out',
                      onTap: () {
                        context.read<LogoutBloc>().add(LogoutRequested());
                      },
                    ),
                  ],
                ),
                if (state is LogoutLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
