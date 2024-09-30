import 'package:flutter/material.dart';

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
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with existing profile data (replace with actual data)
    _nameController.text = 'John Doe';
    _emailController.text = 'johndoe@example.com';
    _locationController.text = 'New York, NY';
    _contactController.text = '(123) 456-7890';
    _professionController.text = 'Software Engineer';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    _professionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(_nameController, 'Name', Icons.person_2_outlined),
            const SizedBox(height: 16),
            _buildTextField(_emailController, 'Email', Icons.email_outlined),
            const SizedBox(height: 16),
            _buildTextField(
                _locationController, 'Location', Icons.location_on_outlined),
            const SizedBox(height: 16),
            _buildTextField(_contactController, 'Contact Number', Icons.phone),
            const SizedBox(height: 16),
            _buildTextField(_professionController, 'Profession',
                Icons.work_outline_outlined),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextField _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlue, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.lightBlue),
        prefixIcon: Icon(icon, color: Colors.lightBlue),
      ),
      maxLines: maxLines,
    );
  }

  void _saveProfile() {
    // Implement save logic here (e.g., send data to the server or update local state)
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String location = _locationController.text;
    final String contact = _contactController.text;
    final String profession = _professionController.text;

    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Profile updated: $name, $email, $location, $contact, $profession,')),
    );
  }
}
