// lib/views/home/section_title_with_dropdown.dart
import 'package:flutter/material.dart';

// Enhanced SectionTitleAboutJob Widget
class SectionTitleAboutJob extends StatefulWidget {
  final String title;

  const SectionTitleAboutJob({Key? key, required this.title}) : super(key: key);

  @override
  _SectionTitleAboutJobState createState() => _SectionTitleAboutJobState();
}

class _SectionTitleAboutJobState extends State<SectionTitleAboutJob>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    // Trigger the scale animation
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _onTap(); // Trigger tap animation
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.white, // Background color
            borderRadius: BorderRadius.circular(10), // Rounded corners
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.work, // Example icon
                    size: 28.0,
                    color: Colors.lightBlue,
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.lightBlue,
                size: 28.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
