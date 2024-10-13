import 'package:flutter/material.dart';

class VerifyAccountCard extends StatefulWidget {
  const VerifyAccountCard({super.key, required Null Function() onPressed});

  @override
  State<VerifyAccountCard> createState() => _VerifyAccountCardState();
}

class _VerifyAccountCardState extends State<VerifyAccountCard> {
  bool isVerified = false; // State to track verification status
  bool isLoading = false; // To track if verification is in progress

  // Function to simulate the verification process
  void verifyAccount() {
    setState(() {
      isLoading = true;
    });

    // Simulate a delay for the verification process
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
        isVerified = true; // Mark as verified
      });

      // Show the Snackbar after loading is complete
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your profile is under review. Please wait for the verification.'),
          duration: Duration(seconds: 3), // Set duration for the Snackbar
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.lightBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.verified_user, color: Colors.white, size: 25),
                SizedBox(width: 10),
                Text(
                  'Verify Your Account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            isVerified
                ? const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 28,
                  )
                : isLoading
                    ? const SizedBox(
                        width: 24, // Set a specific width
                        height: 24, // Set a specific height
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0, // Adjust the stroke width to make it smaller
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          _showVerifyDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          minimumSize: const Size(100, 40),
                        ),
                        child: const Text(
                          'Verify',
                          style: TextStyle(
                            color: Colors.lightBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  // Method to show the first confirmation dialog
  void _showVerifyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Account Verification',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          content: const Text(
              'Are you sure you want to verify your account? This process may take a few moments.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showVerificationProcessingDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
              ),
              child: const Text(
                'Verify',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Method to show the second dialog (processing or success message)
  void _showVerificationProcessingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Verifying...',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
              'Your account is being verified. Please wait a moment.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                verifyAccount(); // Start the verification process
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.lightBlue),
              ),
            ),
          ],
        );
      },
    );
  }
}
