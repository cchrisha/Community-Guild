import 'package:community_guild/repository/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';
import '../widget/profile/profile_header.dart';
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
      )..add(LoadProfile()), // Load initial profile data
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'Edit Info') {
                  // Navigate to EditProfilePage and await result
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                  // If the result is true, reload profile
                  if (result == true) {
                    context.read<ProfileBloc>().add(LoadProfile());
                  }
                } else if (value == 'Settings') {
                  // Navigate to SettingsPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
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
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ProfileLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileHeader(
                      name: state.name,
                      profession: state.profession,
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
}
