// import 'package:flutter/material.dart';

// class ActionButtons extends StatelessWidget {
//   final VoidCallback onCancel;

//   const ActionButtons({super.key, required this.onCancel});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         ElevatedButton(
//           onPressed: () {
//             _showStartJobDialog(context);
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color.fromARGB(255, 3, 169, 244),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             padding: const EdgeInsets.symmetric(
//               vertical: 12,
//               horizontal: 20,
//             ),
//           ),
//           child: const Text(
//             'Start',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _showStartJobDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             'Start',
//             style: TextStyle(
//               fontSize: 16,
//             ),
//           ),
//           content: const Text('Do you want to start this job?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text(
//                 'No',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.lightBlue,
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                       content:
//                           Text('Job successfully start add on pending lists!')),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 3, 169, 244),
//               ),
//               child: const Text(
//                 'Yes',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
