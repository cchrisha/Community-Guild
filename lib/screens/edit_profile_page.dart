import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/edit_profile/edit_profile_event.dart';
import '../bloc/edit_profile/edit_profile_state.dart';
import '../bloc/edit_profile/edit_profile_bloc.dart';
import '../widget/edit_profile/edit_profile_app_bar.dart';
import '../widget/edit_profile/profession_dropdown.dart';
import '../widget/edit_profile/text_field_widget.dart';
import '../widget/edit_profile/save_button.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  String? _selectedProfession;

  final List<String> _professions = [
    'Software Developer',
    'Data Scientist',
    'Graphic Designer',
    'Project Manager',
    'Marketing Specialist',
    'Web Developer',
    'UX/UI Designer',
    'System Administrator',
    'Network Engineer',
    'Database Administrator',
    'Business Analyst',
    'DevOps Engineer',
    'Cybersecurity Analyst',
    'Content Writer',
    'SEO Specialist',
    'Product Manager',
    'Mobile Developer',
    'Game Developer',
    'QA Tester',
    'Technical Support',
    'Cloud Engineer',
    'Artificial Intelligence Engineer',
    'Machine Learning Engineer',
    'Blockchain Developer',
    'Data Analyst',
    'IT Consultant',
    'Digital Marketing Manager',
    'Social Media Manager',
    'Content Strategist',
    'E-commerce Specialist',
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileBloc(),
      child: Scaffold(
        appBar: const EditProfileAppBar(),
        body: BlocListener<EditProfileBloc, EditProfileState>(
          listener: (context, state) {
            if (state is EditProfileSaved) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              Navigator.pop(context);
            } else if (state is EditProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: SingleChildScrollView(
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
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    validator: _validateEmail,
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
                  ProfessionDropdown(
                    selectedProfession: _selectedProfession,
                    professions: _professions,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedProfession = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SaveButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        BlocProvider.of<EditProfileBloc>(context).add(
                          SaveProfileEvent(
                            name: _nameController.text,
                            email: _emailController.text,
                            location: _locationController.text,
                            contact: _contactController.text,
                            profession: _selectedProfession,
                          ),
                        );
                      }
                    },
                    isLoading: false,
                  ),
                ],
              ),
            ),
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

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email';
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
}
