// import 'package:flutter/material.dart';

// class JobContactField extends StatelessWidget {
//   final TextEditingController controller;

//   const JobContactField({super.key, required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: TextInputType.phone,
//       decoration: InputDecoration(
//         labelText: 'Contact',
//         labelStyle: const TextStyle(color: Color.fromARGB(255, 3, 169, 244)),
//         prefixIcon: const Icon(
//           Icons.phone,
//           color: Color.fromARGB(255, 3, 169, 244),
//         ),
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
//         contentPadding:
//             const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter Contact';
//         }
//         return null;
//       },
//     );
//   }
// }
