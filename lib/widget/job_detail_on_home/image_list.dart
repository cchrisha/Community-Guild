// import 'package:flutter/material.dart';

// class ImageList extends StatelessWidget {
//   const ImageList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 200,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: 5, // Replace with actual number of photos
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(15),
//               child: Image.network(
//                 'https://via.placeholder.com/150', // Replace with actual photo URL
//                 fit: BoxFit.cover,
//                 width: 150,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
