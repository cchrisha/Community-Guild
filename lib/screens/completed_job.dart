import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompletedJobDetail extends StatefulWidget {
  const CompletedJobDetail({
    super.key,
    required this.jobTitle,
    required this.jobDescription,
    required this.date,
    required this.wageRange,
    required this.isCrypto,
    required this.professions,
    required this.workPlace,
    required this.contact,
    required this.category,
  });

  final String jobTitle;
  final String jobDescription;
  final String date; // Assuming this is in ISO8601 format or similar
  final String wageRange;
  final bool isCrypto;
  final String professions;
  final String workPlace;
  final String contact;
  final String category;

  @override
  State<CompletedJobDetail> createState() => _CompletedJobDetailState();
}

class _CompletedJobDetailState extends State<CompletedJobDetail> {
  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('MMMM dd, yyyy').format(parsedDate); // Format date
    } catch (e) {
      return date; // Return the original date string if parsing fails
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[100],
    appBar: AppBar(
      title: const Text(
        'Job Details',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 4.0,
              color: Colors.black38,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blueAccent,
       automaticallyImplyLeading: false,
      elevation: 8,
      centerTitle: true,
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [  
            GestureDetector(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.lightBlueAccent,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.contact,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 0),
              const Divider(color: Color(0xFF03A9F4), thickness: 1.2),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  widget.jobTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Center(
                child: Text(
                  widget.category,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Card(
                  color: const Color.fromARGB(255, 254, 254, 254),
                  margin: EdgeInsets.zero, // Remove margin to use full width
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 200,
                      width: 400,
                      child: SingleChildScrollView(
                        child: Text(
                          widget.jobDescription,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailIcon(Icons.work, widget.professions),
                  const VerticalDivider(thickness: 1, color: Color.fromARGB(66, 0, 0, 0), width: 2),
                  _buildDetailIcon(Icons.location_on, widget.workPlace),
                  const VerticalDivider(thickness: 1, color: Color.fromARGB(66, 0, 0, 0), width: 2),
                  _buildDetailIcon(Icons.monetization_on, widget.wageRange),
                  const VerticalDivider(thickness: 1, color: Color.fromARGB(66, 0, 0, 0), width: 2),
                  _buildDetailIcon(widget.isCrypto ? Icons.currency_bitcoin : Icons.money_off, ''),
                ],
              ),
              const SizedBox(height: 50),
               Center(
              child: SizedBox(
                width: 130,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigate back to JobPage
                  },
                  child: const Text(
                    'Back',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }

// Helper method to build detail rows
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }
  Widget _buildDetailIcon(IconData icon, String data) {
    return Column(
      children: [
        Icon(icon, size: 30, color: const Color(0xFF03A9F4)),
        const SizedBox(height: 10),
        SizedBox(
          width: 80,
          child: Text(
            data.isNotEmpty ? data : (icon == Icons.money_off ? 'Not Crypto' : 'Crypto'),
            style: const TextStyle(fontSize: 16, color: Color.fromARGB(137, 0, 0, 0)),
            maxLines: 3,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
