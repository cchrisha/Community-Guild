import 'package:flutter/material.dart';

class PendingJobButtons extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onStart;

  const PendingJobButtons({
    super.key,
    required this.onCancel,
    required this.onStart,
  });

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Cancel'),
          content: const Text('Are you sure you want to cancel this job?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.lightBlue),
              ),
            ),
            TextButton(
              onPressed: () {
                onCancel(); // Call the onCancel callback
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 3, 169, 244),
              ),
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showStartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Start Job'),
          content: const Text('Start the job now?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.lightBlue),
              ),
            ),
            TextButton(
              onPressed: () {
                onStart(); // Call the onStart callback
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 3, 169, 244),
              ),
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () => _showCancelDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 245, 238, 238),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 20,
            ),
          ),
          child: const Text(
            'Cancel this job',
            style: TextStyle(fontSize: 16, color: Colors.lightBlue),
          ),
        ),
        ElevatedButton(
          onPressed: () => _showStartDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 20,
            ),
          ),
          child: const Text(
            'Start',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
