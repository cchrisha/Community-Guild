import 'package:flutter/material.dart';

class JobProfessionDropdown extends StatelessWidget {
  final String? selectedProfession;
  final List<String> professions;
  final ValueChanged<String?> onChanged;

  const JobProfessionDropdown({
    super.key,
    required this.selectedProfession,
    required this.onChanged,
    required this.professions,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedProfession,
      decoration: InputDecoration(
        labelText: 'Profession',
        labelStyle: const TextStyle(color: Color.fromARGB(255, 3, 169, 244)),
        prefixIcon: const Icon(
          Icons.business_center,
          color: Color.fromARGB(255, 3, 169, 244),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 3, 169, 244), width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 3, 169, 244), width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.red, width: 2), // Change color to red for error
          borderRadius: BorderRadius.circular(16),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.red, width: 2), // Change color to red for error
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      items: professions.map((String profession) {
        return DropdownMenuItem<String>(
          value: profession,
          child: Text(profession),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Please select a Profession';
        }
        return null;
      },
    );
  }
}
