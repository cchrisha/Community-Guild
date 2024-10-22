import 'package:community_guild/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/edit_profile/edit_profile_bloc.dart';
import '../bloc/edit_profile/edit_profile_event.dart';
import '../bloc/edit_profile/edit_profile_state.dart';
import '../repository/profile_repository.dart';
import '../widget/edit_profile/save_button.dart';
import '../widget/edit_profile/text_field_widget.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final profileRepository = ProfileRepository();
    try {
      final userProfile =
          await profileRepository.fetchProfile(); // Use fetchProfile instead
      _nameController.text = userProfile['name'];
      _locationController.text = userProfile['location'];
      _contactController.text = userProfile['contact'];
      _professionController.text =
          userProfile['profession']; // Set the selected profession
    } catch (error) {
      // Handle errors, maybe show a Snackbar or dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch profile data: $error')),
      );
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    _nameController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileBloc(
        profileRepository: ProfileRepository(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit Profile',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.lightBlue,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ),
        body: BlocListener<EditProfileBloc, EditProfileState>(
          listener: (context, state) {
            if (state is EditProfileSaved) {
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              // Pop and return true to indicate success
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const ProfilePage()), // Replace ProfilePage with your target page
              ); // Returning true to indicate success
            } else if (state is EditProfileError) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocBuilder<EditProfileBloc, EditProfileState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldWidget(
                        controller: _nameController,
                        label: 'Name',
                        icon: Icons.person_2_outlined,
                        validator: _validateName,
                      ),
                      const SizedBox(height: 16),
                      TextFieldWidget(
                        controller: _locationController,
                        label: 'Location',
                        icon: Icons.location_on_outlined,
                        validator: _validateLocation,
                      ),
                      const SizedBox(height: 16),
                      TextFieldWidget(
                        controller: _contactController,
                        label: 'Contact',
                        icon: Icons.phone_outlined,
                        validator: _validateContact,
                      ),
                      const SizedBox(height: 16),
                      TextFieldWidget(
                          controller: _professionController,
                          label: 'Profession',
                          icon: Icons.work_outline,
                          validator: _validateProfession),
                      // Profession Dropdown
                      // DropdownButtonFormField<String>(
                      //   decoration: const InputDecoration(
                      //     labelText: 'Profession',
                      //     prefixIcon: Icon(Icons.work),
                      //   ),
                      //   value: _selectedProfession,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _selectedProfession = value!;
                      //     });
                      //   },
                      //   items: _professions.map<DropdownMenuItem<String>>(
                      //     (String profession) {
                      //       return DropdownMenuItem<String>(
                      //         value: profession,
                      //         child: Text(profession),
                      //       );
                      //     },
                      //   ).toList(),
                      // ),
                      const SizedBox(height: 16),
                      SaveButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Dispatch the SaveProfileEvent here
                            context.read<EditProfileBloc>().add(
                                  SaveProfileEvent(
                                    name: _nameController.text,
                                    location: _locationController.text,
                                    contact: _contactController.text,
                                    profession: _professionController
                                        .text, // Send selected profession
                                  ),
                                );
                          }
                        },
                        isLoading: state is EditProfileLoading,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your location';
    }
    return null;
  }

  String? _validateContact(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your contact number';
    }
    return null;
  }

  String? _validateProfession(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your profession';
    }
    return null;
  }
}
