import 'dart:io';
import 'package:community_guild/repository/profile_repository.dart';
import 'package:community_guild/widget/profile/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';
import '../widget/home/section_title.dart';
import '../widget/loading_widget/ink_drop.dart';
import '../widget/profile/profession_info_card.dart';
import '../widget/profile/profile_info_card.dart';
import 'edit_profile_page.dart';
import 'setting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                  if (result == true) {
                    context.read<ProfileBloc>().add(LoadProfile());
                  }
                } else if (value == 'Settings') {
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
              icon: const Icon(Icons.more_vert, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(
                child: InkDrop(
                  size: 40,
                  color: Colors.lightBlue,
                  ringColor: Colors.lightBlue.withOpacity(0.2),
                ),
              );
            } else if (state is ProfileLoaded) {
              return _buildProfileContent(context, state);
            } else if (state is ProfileError) {
              return Center(child: Text(state.error));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

Widget _buildProfileContent(BuildContext context, ProfileLoaded state) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildProfilePictureSection(context, state),
        const SizedBox(height: 0),
        ProfileHeader(name: state.name, profession: state.profession),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () async {
            await _sendVerificationRequest(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue, // Button color
          ),
          child: const Text('Verify', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 15),
        const SectionTitle(title: 'Contact Info:'),
        ProfileInfoCard(
          location: state.location,
          contact: state.contact,
          email: state.email,
        ),
        const SizedBox(height: 15),
        const SectionTitle(title: 'Professional Info:'),
        ProfessionInfoCard(
          profession: state.profession,
        ),
      ],
    ),
  );
}

Future<void> _sendVerificationRequest(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getString('auth_token'); // Retrieve the auth_token

  if (authToken == null) {
    // Handle case where the token is missing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Authentication token not found')),
    );
    return;
  }

  final url = 'https://api-tau-plum.vercel.app/api/notifications/request-verification'; // Replace with your actual API URL

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken', // Use the retrieved auth token
      },
    );

    if (response.statusCode == 201) {
      // Show success notification to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification request sent successfully')),
      );
    } else {
      // Handle other response codes (e.g., 404 or 500)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.statusCode}')),
      );
    }
  } catch (e) {
    // Handle any errors during the request
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}


  Widget _buildProfilePictureSection(BuildContext context, ProfileLoaded state) {
    final profileBloc = context.read<ProfileBloc>();

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.lightBlue, // Border color
              width: 4.0, // Keep the blue border
            ),
          ),
          child: CircleAvatar(
            radius: 70, // Outer avatar size including border
            backgroundColor: Colors.transparent, // No background color
            child: CircleAvatar(
              radius: 70, // Adjusted to create space for the blue border
              backgroundImage: state.profilePictureUrl.isNotEmpty
                  ? NetworkImage(state.profilePictureUrl)
                  : const AssetImage('assets/default_profile.png')
                      as ImageProvider,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 40,
            height: 40, // Adjust size for camera icon
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.lightBlue, // Icon background color
              border: Border.all(
                color: Colors.white,
                width: 3, // Border width around icon
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  profileBloc.add(UploadProfilePicture(File(image.path)));
                }
              },
              iconSize: 20,
              padding: EdgeInsets.zero,
              splashRadius: 28,
            ),
          ),
        ),
      ],
    );
  }
}
