// import 'package:flutter/material.dart';
// import 'balance_card.dart';

// class AppBarSection extends StatelessWidget {
//   final String balance;
//   final String address;

//   const AppBarSection({
//     super.key,
//     required this.balance,
//     required this.address,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SliverAppBar(
//       automaticallyImplyLeading: false,
//       pinned: true,
//       expandedHeight: 200.0,
//       flexibleSpace: FlexibleSpaceBar(
//         title: const SizedBox.shrink(),
//         background: Container(
//           color: const Color.fromARGB(255, 3, 169, 244),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Spacer(),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   children: [
//                     BalanceCard(balance: balance, address: address),
//                     const SizedBox(width: 5),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: const [
//         Expanded(
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: Padding(
//               padding: EdgeInsets.only(left: 30.0),
//               child: Text(
//                 'Payment',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
