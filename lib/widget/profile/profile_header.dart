import 'package:community_guild/bloc/profile/profile_bloc.dart';
import 'package:community_guild/bloc/profile/profile_event.dart';
import 'package:community_guild/bloc/profile/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileHeader extends StatefulWidget {
  final String name;
  final String profession;
  final String profilePicture; 

  const ProfileHeader({
    Key? key,
    required this.name,
    required this.profession,
    required this.profilePicture,
  }) : super(key: key);

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  File? _profileImage; // Currently displayed profile image
  File? _tempImage; // Temporarily holds the selected image

  @override
  void initState() {
    super.initState();
    _profileImage = widget.profilePicture.isNotEmpty 
        ? File(widget.profilePicture) 
        : null;
  }

  void _showChangeProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Change Profile Picture',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_camera,
                  color: Colors.lightBlue,
                ),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Colors.lightBlue,
                ),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.lightBlue),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _tempImage = File(pickedFile.path);
      });
      _uploadProfilePicture(_tempImage!); 
    }
  }

  void _uploadProfilePicture(File image) {
    // Dispatch an event to upload the selected profile picture
    final bloc = BlocProvider.of<ProfileBloc>(context);
    bloc.add(UploadProfilePicture(image));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: _showChangeProfileDialog,
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  String profilePictureUrl = widget.profilePicture;
                  
                  // If the profile picture is updated, load it
                  if (state is ProfilePictureUploaded) {
                    profilePictureUrl = state.profilePictureUrl;
                  }

                  return CircleAvatar(
                    radius: 60,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : (profilePictureUrl.isNotEmpty
                            ? NetworkImage(profilePictureUrl) // Load from URL
                            : const AssetImage('assets/images/profile.png') as ImageProvider),
                    backgroundColor: Colors.lightBlue,
                    child: _profileImage == null && profilePictureUrl.isEmpty
                        ? const Icon(Icons.person, color: Colors.white, size: 60)
                        : null,
                  );
                },
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
                  onPressed: _showChangeProfileDialog,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          widget.name,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          widget.profession,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.lightBlue,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
