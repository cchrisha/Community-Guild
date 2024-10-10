// import 'package:flutter/material.dart';
// import 'job_card.dart';

// class TransactionsSection extends StatelessWidget {
//   final bool isLoading;
//   final List transactions;

//   const TransactionsSection({
//     super.key,
//     required this.isLoading,
//     required this.transactions,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Transactions',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : Container(
//                 height: 350,
//                 child: ListView.builder(
//                   itemCount: transactions.length,
//                   itemBuilder: (context, index) {
//                     final transaction = transactions[index];
//                     return PaymentJobCardPage(
//                       amount: transaction.amount,
//                       sender: transaction.sender,
//                       recipient: transaction.recipient,
//                       hash: transaction.hash,
//                       date: transaction.date,
//                       isSent: transaction.isSent,
//                     );
//                   },
//                 ),
//               ),
//       ],
//     );
//   }
// }
