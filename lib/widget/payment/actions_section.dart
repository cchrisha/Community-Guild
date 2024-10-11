// import 'package:flutter/material.dart';
// import 'package:community_guild/widgets/appkit_modal_connect_button.dart';
// import 'package:community_guild/widgets/appkit_modal_network_select_button.dart';
// import 'package:reown_appkit/modal/widgets/public/appkit_modal_connect_button.dart';
// import 'package:reown_appkit/reown_appkit.dart';

// class ActionsSection extends StatelessWidget {
//   final bool isConnected;
//   final Function() onSend;
//   final Function() onReceive;
//   final Function() onConnectDisconnect;

//   const ActionsSection({
//     Key? key,
//     required this.isConnected,
//     required this.onSend,
//     required this.onReceive,
//     required this.onConnectDisconnect,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Actions',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             const SizedBox(height: 16),
//             AppKitModalConnectButton(
//               appKit: null, // Pass the actual AppKit instance
//               custom: ElevatedButton(
//                 onPressed: onConnectDisconnect,
//                 child: Text(isConnected ? 'Disconnect' : 'Connect Wallet'),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Visibility(
//               visible: !isConnected,
//               child: AppKitModalNetworkSelectButton(
//                   appKit: null), // Pass the actual AppKit instance
//             ),
//             const SizedBox(height: 16),
//             Visibility(
//               visible: isConnected,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: onSend,
//                     child: const Text('Send'),
//                   ),
//                   const SizedBox(width: 17),
//                   ElevatedButton(
//                     onPressed: onReceive,
//                     child: const Text('Receive'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
