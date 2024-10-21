import 'package:flutter/material.dart';

class PostButton extends StatefulWidget {
  final VoidCallback onPressed;

  const PostButton({super.key, required this.onPressed});

  @override
  _PostButtonState createState() => _PostButtonState();
}

class _PostButtonState extends State<PostButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _isPressed ? 2 : 0, 0),
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color.fromARGB(255, 2, 136, 209) // Darker blue on hover
                : const Color.fromARGB(255, 3, 169, 244), // Regular color
            borderRadius: BorderRadius.circular(10),
            boxShadow: _isPressed
                ? []
                : [
                    BoxShadow(
                      color: Colors.blue.withOpacity(_isHovered ? 0.6 : 0.4),
                      blurRadius: _isHovered ? 12 : 8,
                      offset: Offset(0, _isHovered ? 6 : 4),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              splashColor: Colors.white.withOpacity(0.2), // Ripple effect
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 140, vertical: 10),
                alignment: Alignment.center,
                child: const Text(
                  'Post Job',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
