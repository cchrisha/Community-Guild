// import 'package:flutter/material.dart';

// class ProfessionDropdown extends StatelessWidget {
//   final String? selectedProfession;
//   final List<String> professions;
//   final Function(String?) onChanged;

//   const ProfessionDropdown({
//     super.key,
//     required this.selectedProfession,
//     required this.professions,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String>(
//       decoration: InputDecoration(
//         labelText: 'Profession',
//         labelStyle: const TextStyle(color: Color.fromARGB(255, 3, 169, 244)),
//         enabledBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//               color: Color.fromARGB(255, 3, 169, 244), width: 2),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//               color: Color.fromARGB(255, 3, 169, 244), width: 2),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//               color: Colors.red, width: 2), // Change the color to red
//           borderRadius: BorderRadius.circular(16),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//               color: Colors.red, width: 2), // Change the color to red
//           borderRadius: BorderRadius.circular(16),
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//       ),
//       value: selectedProfession,
//       items: professions.map((String profession) {
//         return DropdownMenuItem<String>(
//           value: profession,
//           child: Text(profession),
//         );
//       }).toList(),
//       onChanged: onChanged,
//       validator: (value) => value == null ? 'Please select a profession' : null,
//     );
//   }
// }
