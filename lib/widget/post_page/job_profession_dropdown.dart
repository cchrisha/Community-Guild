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
        labelStyle: const TextStyle(color: Colors.blueAccent),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
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
