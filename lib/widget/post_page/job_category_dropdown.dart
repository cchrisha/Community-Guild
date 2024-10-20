import 'package:flutter/material.dart';

class JobCategoryDropdown extends StatelessWidget {
  final String? selectedCategory;
  final List<String> categories;
  final ValueChanged<String?> onChanged;

  const JobCategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      decoration: InputDecoration(
        labelText: 'Category',
        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        prefixIcon: const Icon(
          Icons.category,
          color: Color.fromARGB(255, 5, 6, 6),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 7, 8, 8), width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 0, 0, 0), width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      items: categories.map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Please select a Category';
        }
        return null;
      },
    );
  }
}
