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
        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        prefixIcon: const Icon(Icons.title, color: Color.fromARGB(255, 0, 0, 0)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }
}
 