import 'package:flutter/material.dart';
import 'package:community_guild/screens/edit_profile_page.dart';
import 'package:community_guild/screens/setting.dart';
import 'package:community_guild/widget/profile/profile_header.dart';
import 'package:community_guild/widget/profile/section_with_see_all.dart';
import 'package:community_guild/widget/profile/additional_info.dart';
import 'package:community_guild/widget/profile/completed_job_card.dart';
import 'package:community_guild/widget/profile/post_job_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
        actions: [
          PopupMenuTheme(
            data: const PopupMenuThemeData(
              color: Colors.white,
            ),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'Edit Profile') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfilePage()),
                  );
                } else if (value == 'Settings') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()),
                  );
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'Edit Profile',
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Settings',
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ];
              },
              icon: const Icon(Icons.menu, color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ProfileHeader(),
            const SizedBox(height: 30),
            _buildSection(
              context,
              'Additional Info:',
              const AdditionalInfo(),
              onEdit: () {
                // Handle edit action if needed
              },
            ),
            const SizedBox(height: 30),
            _buildSection(
              context,
              'Completed Jobs',
              const CompletedJobCard(),
            ),
            const SizedBox(height: 30),
            _buildSection(
              context,
              'Posted Jobs',
              const PostJobCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content,
      {VoidCallback? onEdit, VoidCallback? seeAll}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionWithSeeAll(
          title: title,
          onSeeAll: seeAll ?? () {},
        ),
        const SizedBox(height: 10),
        content,
      ],
    );
  }
}
