// import 'package:flutter/material.dart';

// class NotificationPage extends StatelessWidget {
//   const NotificationPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text(
//           'Notification',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Colors.lightBlue,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16.0),
//         itemCount: notifications.length,
//         itemBuilder: (context, index) {
//           return Card(
//             margin: const EdgeInsets.only(bottom: 16.0),
//             child: ListTile(
//               title: Text(notifications[index].title),
//               subtitle: Text(notifications[index].subtitle),
//               onTap: () {
//                 _showNotificationDialog(context, notifications[index]);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _showNotificationDialog(
//       BuildContext context, NotificationItem notification) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(notification.title),
//           content: Text(notification.message),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Proceed'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const AnotherPage()),
//                 );
//               },
//             ),
//             TextButton(
//               child: const Text('Close'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class NotificationItem {
//   final String title;
//   final String subtitle;
//   final String message;

//   NotificationItem({
//     required this.title,
//     required this.subtitle,
//     required this.message,
//   });
// }

// List<NotificationItem> notifications = [
//   NotificationItem(
//     title: 'Someone accepted your job offer',
//     subtitle: 'Check out your job offer.',
//     message:
//         'A new job in your preferred category has been posted. Check it out now!',
//   ),
//   NotificationItem(
//     title: 'Payment Received',
//     subtitle: 'You have received a new payment',
//     message: 'You have received a payment of ₱500.00. Check your balance now!',
//   ),
// ];

// class AnotherPage extends StatelessWidget {
//   const AnotherPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Another Page'),
//       ),
//       body: const Center(
//         child: Text('This is another page'),
//       ),
//     );
//   }
// }
