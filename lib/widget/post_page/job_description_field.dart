import 'package:flutter/material.dart';

class JobDescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const JobDescriptionField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 5,
      decoration: InputDecoration(
        labelText: 'Job Description',
        labelStyle: const TextStyle(color: Color.fromARGB(255, 3, 169, 244)),
        prefixIcon: const Icon(Icons.description, color: Color.fromARGB(255, 3, 169, 244)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 3, 169, 244), width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 3, 169, 244), width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Job Description';
        }
        return null;
      },
    );
  }
}
