// import 'package:flutter/material.dart';

// class CurrentInfoCard extends StatelessWidget {
//   final bool isExpanded;
//   final VoidCallback toggleExpansion;

//   const CurrentInfoCard(
//       {required this.isExpanded, required this.toggleExpansion, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 180,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.lightBlueAccent, Colors.blueAccent],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
//       ),
//       child: Stack(
//         children: [
//           Positioned(
//             top: 28,
//             left: 16,
//             right: 16,
//             child: GestureDetector(
//               onTap: toggleExpansion,
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 curve: Curves.easeInOut,
//                 height: isExpanded ? 180 : 120,
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   elevation: 3,
//                   child: Stack(
//                     children: [
//                       const Positioned(
//                         top: 16,
//                         left: 16,
//                         child: CircleAvatar(
//                           radius: 30,
//                           backgroundColor: Colors.lightBlueAccent,
//                           child:
//                               Icon(Icons.person, color: Colors.white, size: 30),
//                         ),
//                       ),
//                       Positioned(
//                         left: 72,
//                         top: 16,
//                         right: 16,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 20.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Lana',
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black87,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               const SizedBox(height: 5),
//                               const Text(
//                                 'Location: Mangaldan Pangasinan',
//                                 style: TextStyle(color: Colors.black54),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               const Text(
//                                 'Profession: Electrician',
//                                 style: TextStyle(color: Colors.black54),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               if (isExpanded) ...[
//                                 const SizedBox(height: 10),
//                                 const Text(
//                                   'Contact: +63 912 345 6789',
//                                   style: TextStyle(color: Colors.black54),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 const Text(
//                                   'Email: example@example.com',
//                                   style: TextStyle(color: Colors.black54),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
