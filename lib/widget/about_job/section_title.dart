import 'package:flutter/material.dart';

class SectionTitleAboutJob extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback? onTap;

  const SectionTitleAboutJob({
    Key? key,
    required this.title,
    required this.isExpanded,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 8.0, horizontal: 10.0), // Reduced padding
        margin: const EdgeInsets.symmetric(vertical: 4.0), // Reduced margin
        decoration: BoxDecoration(
          color: const Color(0xFF4a90e2), // Solid blue color background
          borderRadius: BorderRadius.circular(8), // Reduced border radius
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Info card styled with a colored left border
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10.0), // Reduced padding
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(6.0), // Reduced border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border(
                    left: BorderSide(
                      color: Colors.blue.withOpacity(0.3), // Light blue border
                      width: 4.0, // Thinner border
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0, // Smaller font size
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2.0), // Reduced space
                  ],
                ),
              ),
            ),
            AnimatedRotation(
              turns: isExpanded ? 1 / 4 : 0,
              duration: const Duration(milliseconds: 400),
              child: const Icon(
                Icons.chevron_right,
                size: 20.0, // Smaller icon size
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
