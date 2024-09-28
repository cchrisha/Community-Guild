// lib/views/home/section_title_with_dropdown.dart
import 'package:flutter/material.dart';

class SectionTitleWithDropdown extends StatelessWidget {
  final String title;

  const SectionTitleWithDropdown({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        DropdownButton<String>(
          items:
              <String>['Option 1', 'Option 2', 'Option 3'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (_) {},
          icon: const Icon(Icons.arrow_drop_down),
          underline: const SizedBox(),
        ),
      ],
    );
  }
}
