import 'package:flutter/material.dart';

class JobProgressBar extends StatelessWidget {
  const JobProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 5,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
          ),
          child: Slider(
            value: 0.5, // Progress Bar Value
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
          ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Start'),
            Text('In Progress'),
            Text('Completed'),
          ],
        ),
      ],
    );
  }
}
