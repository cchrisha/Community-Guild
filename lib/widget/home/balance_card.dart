// // lib/views/home/balance_card.dart
// import 'package:flutter/material.dart';

// class HomeBalanceCard extends StatelessWidget {
//   const HomeBalanceCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 130,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(255, 3, 169, 244),
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: const Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Current Balance:',
//                 style: TextStyle(fontSize: 18, color: Colors.white)),
//             Text('₱ 23,587',
//                 style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white)),
//           ],
//         ),
//       ),
//     );
//   }
// }
