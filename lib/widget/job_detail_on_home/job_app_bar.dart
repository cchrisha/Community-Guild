// import 'package:flutter/material.dart';

// class JobAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final VoidCallback onBackPressed;

//   const JobAppBar({super.key, required this.onBackPressed});

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: const Text(
//         'Job Details',
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
//         onPressed: onBackPressed,
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.share, color: Colors.white),
//           onPressed: () {
//             // Implement share functionality
//           },
//         ),
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
