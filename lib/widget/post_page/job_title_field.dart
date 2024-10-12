import 'package:flutter/material.dart';

class JobTitleField extends StatelessWidget {
  final TextEditingController controller;

  const JobTitleField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Job Title',
        labelStyle: const TextStyle(color: Color.fromARGB(255, 3, 169, 244)),
        prefixIcon: const Icon(Icons.title, color: Color.fromARGB(255, 3, 169, 244)),
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
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2), // Red border when focused with an error
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Job Title';
        }
        return null;
      },
    );
  }
}
