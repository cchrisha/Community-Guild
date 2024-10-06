import 'package:community_guild/repository/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';
import '../widget/profile/completed_job_card.dart';
import '../widget/profile/post_job_card.dart';
import '../widget/profile/profile_header.dart';
import '../widget/profile/section_with_see_all.dart';
import '../widget/profile/verify_account_card.dart';
import '../widget/profile/profile_info_card.dart';
import 'edit_profile_page.dart';
import 'setting.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        profileRepository: ProfileRepository(),
      )..add(LoadProfile()),
      child: Scaffold(
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
              data: const PopupMenuThemeData(color: Colors.white),
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Edit Info') {
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
                      value: 'Edit Info',
                      child: Text(
                        'Edit Info',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Settings',
                      child: Text(
                        'Settings',
                        style: TextStyle(color: Colors.black),
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
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileHeader(
                      name: state
                          .name, // Pass the name from the ProfileLoaded state
                      profession: state
                          .profession, // Pass the profession from the ProfileLoaded state
                    ),
                    const SizedBox(height: 15),
                    VerifyAccountCard(
                      onPressed: () {
                        BlocProvider.of<ProfileBloc>(context)
                            .add(VerifyAccount());
                      },
                    ),
                    const SizedBox(height: 30),
                    ProfileInfoCard(
                      location: state.location,
                      contact: state.contact,
                      email: state.email,
                      profession: state.profession,
                    ),
                    const SizedBox(height: 30),
                    _buildSection(
                        context, 'Completed Jobs', const CompletedJobCard()),
                    const SizedBox(height: 30),
                    _buildSection(context, 'Posted Jobs', const PostJobCard()),
                  ],
                );
              } else if (state is ProfileError) {
                return Center(child: Text(state.error));
              }
              return const SizedBox.shrink();
            },
          ),
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
