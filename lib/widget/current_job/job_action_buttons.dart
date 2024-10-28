// import 'package:flutter/material.dart';

// class JobActionButtons extends StatelessWidget {
//   const JobActionButtons({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // Cancel this job button
//         ElevatedButton(
//           onPressed: () {
//             _showCancelJobDialog(context);
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color.fromARGB(255, 239, 238, 238),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             padding: const EdgeInsets.symmetric(
//               vertical: 12,
//               horizontal: 20,
//             ),
//           ),
//           child: const Text(
//             'Cancel this job',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.lightBlue,
//             ),
//           ),
//         ),

//         // Mark as completed button
//         ElevatedButton(
//           onPressed: () {
//             _showCompleteJobDialog(context);
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.lightBlue, // Completed button color
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             padding: const EdgeInsets.symmetric(
//               vertical: 12,
//               horizontal: 20,
//             ),
//           ),
//           child: const Text(
//             'Mark as Completed',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // Function to show dialog for cancelling the job
//   void _showCancelJobDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             'Cancel Job',
//             style: TextStyle(
//               fontSize: 16,
//             ),
//           ),
//           content: const Text('Are you sure you want to cancel this job?'),
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
//                 // Add your logic for cancelling the job here
//                 Navigator.of(context).pop();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Job cancelled successfully!')),
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

//   // Function to show dialog for marking the job as completed
//   void _showCompleteJobDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             'Complete Job',
//             style: TextStyle(fontSize: 16),
//           ),
//           content: const Text(
//               'Are you sure you want to mark this job as completed?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text(
//                 'No',
//                 style: TextStyle(fontSize: 16, color: Colors.lightBlue),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Add your logic for completing the job here
//                 Navigator.of(context).pop();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Job marked as completed!')),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.lightBlue,
//               ),
//               child: const Text(
//                 'Yes',
//                 style: TextStyle(fontSize: 16, color: Colors.white),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
