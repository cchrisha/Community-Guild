import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:community_guild/bloc/pfp/profilepicture_bloc.dart';
import 'package:community_guild/bloc/pfp/profilepicture_event.dart';
import 'package:community_guild/bloc/pfp/profilepicture_state.dart';

class ProfileHeader extends StatefulWidget {
  final String name;
  final String profession;

  const ProfileHeader({
    Key? key,
    required this.name,
    required this.profession,
  }) : super(key: key);

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    // Fetch the initial profile picture when the widget is created
    _fetchProfilePicture();
  }

  Future<void> _fetchProfilePicture() async {
    // Assuming you have a method to fetch the profile picture URL
    final bloc = context.read<ProfilePictureBloc>();
    bloc.add(FetchProfilePicture());
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
        _profileImage = File(pickedFile.path);
      });

      // Dispatch the upload event to the bloc
      context
          .read<ProfilePictureBloc>()
          .add(UploadProfilePicture(_profileImage!));

      // Show a snackbar indicating upload is in progress
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uploading profile picture...')),
      );
    }
  }

  void _showFullProfilePicture() {
    if (_profileImage != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black.withOpacity(0.0),
              ),
              padding: const EdgeInsets.all(16),
              child: Image.file(
                _profileImage!,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfilePictureBloc, ProfilePictureState>(
      listener: (context, state) {
        if (state is ProfilePictureUploading) {
          // Optionally show a loading indicator
        } else if (state is ProfilePictureUploaded) {
          setState(() {
            _profileImage = File(state.profilePictureUrl);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile picture uploaded successfully!')),
          );
        } else if (state is ProfilePictureError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      child: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: _showFullProfilePicture,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const AssetImage('') as ImageProvider,
                  backgroundColor: Colors.lightBlue,
                  child: _profileImage == null
                      ? const Icon(Icons.person, color: Colors.white, size: 60)
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
      ),
    );
  }
}
