import 'package:flutter/material.dart';

class PostButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PostButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 3, 169, 244),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'Post Job',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
