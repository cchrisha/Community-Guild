// import 'package:flutter/material.dart';

// class OwnPostJobAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final Function(int) onSelected;

//   const OwnPostJobAppBar({super.key, required this.onSelected});

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: const Text(
//         'Your Post Job',
//         style: TextStyle(
//           fontSize: 20,
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       backgroundColor: Colors.lightBlue,
//       elevation: 0,
//       centerTitle: true,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back, color: Colors.white),
//         onPressed: () {
//           Navigator.pop(context);
//         },
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.share, color: Colors.white),
//           onPressed: () {},
//         ),
//         PopupMenuButton<int>(
//           icon: const Icon(Icons.more_vert, color: Colors.white),
//           onSelected: (item) => onSelected(item),
//           itemBuilder: (context) => [
//             const PopupMenuItem<int>(value: 0, child: Text('Edit')),
//             const PopupMenuItem<int>(value: 1, child: Text('Delete')),
//           ],
//         ),
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
