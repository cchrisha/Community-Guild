import 'package:community_guild/bloc/pfp/profilepicture_bloc.dart';
import 'package:community_guild/bloc/pfp/profilepicture_event.dart';
import 'package:community_guild/bloc/pfp/profilepicture_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileHeader extends StatefulWidget {
  final String name;
  final String profession;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.profession,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  File? _profileImage; // Currently displayed profile image
  File? _tempImage; // Temporarily holds the selected image

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
        _tempImage =
            File(pickedFile.path); // Store the picked image temporarily
      });

      // Show dialog to confirm saving the profile picture
      _showSaveProfileDialog();
    }
  }

  void _showSaveProfileDialog() {
    if (_tempImage == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Save Profile Picture?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.file(_tempImage!,
                  width: 200, height: 200), // Show the selected image
              const SizedBox(height: 10),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Dispatch the event to change the profile picture using ProfilePictureBloc
                context.read<ProfilePictureBloc>().add(
                      UploadProfilePicture(
                          _tempImage!), // Pass the selected image
                    );

                setState(() {
                  _profileImage = _tempImage; // Save the selected image
                });
                Navigator.pop(context);

                // Optionally show a snackbar or any other feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile picture uploaded!')),
                );
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.lightBlue),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _tempImage = null;
                });
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.lightBlue),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFullProfilePicture() {
    if (_profileImage != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor:
                Colors.transparent, // Set background to transparent
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black
                    .withOpacity(0.0), // Semi-transparent black background
              ),
              padding: const EdgeInsets.all(16),
              child: Image.file(
                _profileImage!,
                fit: BoxFit.cover, // Ensure the image covers the dialog
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePictureBloc, ProfilePictureState>(
      builder: (context, state) {
        if (state is ProfilePictureUploaded) {
          // Update the profile image URL after successful upload
          setState(() {
            _profileImage = File(
                state.profilePictureUrl); // Use the URL as a local file for now
          });
        }

        return Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: _showFullProfilePicture,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('assets/images/profile.png')
                            as ImageProvider,
                    backgroundColor: Colors.lightBlue,
                    child: _profileImage == null
                        ? const Icon(Icons.person,
                            color: Colors.white, size: 60)
                        : null,
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
              widget.name, // Display the passed name
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.profession, // Display the passed profession
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.lightBlue,
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
