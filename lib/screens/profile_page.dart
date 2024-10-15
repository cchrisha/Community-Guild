import 'dart:io';
import 'package:community_guild/repository/profile_repository.dart';
import 'package:community_guild/widget/profile/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';
import '../widget/profile/profile_info_card.dart';
import 'edit_profile_page.dart';
import 'setting.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        profileRepository: ProfileRepository(),
      )..add(LoadProfile()),
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
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfilePage()),
                  );
                  if (result == true) {
                      context.read<ProfileBloc>().add(LoadProfile());}
                } else if (value == 'Settings') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'Edit Info',
                    child: Text('Edit Info', style: TextStyle(color: Colors.black)),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Settings',
                    child: Text('Settings', style: TextStyle(color: Colors.black)),
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
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileLoaded) {
                return _buildProfileContent(context, state);
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

  Widget _buildProfileContent(BuildContext context, ProfileLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildProfilePictureSection(context, state),
        const SizedBox(height: 15),
        ProfileHeader(name: state.name, profession: state.profession),
        const SizedBox(height: 30),
        ProfileInfoCard(
          location: state.location,
          contact: state.contact,
          email: state.email,
          profession: state.profession,
        ),
      ],
    );
  }

  Widget _buildProfilePictureSection(BuildContext context, ProfileLoaded state) {
  final profileBloc = context.read<ProfileBloc>();

  return Column(
    children: [
      Stack(
        children: [
          GestureDetector(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: state.profilePictureUrl.isNotEmpty
                  ? NetworkImage(state.profilePictureUrl)
                  : const AssetImage('assets/default_profile.png') as ImageProvider,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightBlue,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    profileBloc.add(UploadProfilePicture(File(image.path)));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
}