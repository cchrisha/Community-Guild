import 'package:flutter/material.dart';

class RequestedJobCard extends StatelessWidget {
  final String jobTitle;
  final String jobDescription;
  final String workPlace;
  final String date;
  final String wageRange;
  final String category;
  final bool isCrypto;
  final String contact;
  final String professions;
  final VoidCallback onTap;

  const RequestedJobCard({
    super.key,
    required this.jobTitle,
    required this.jobDescription,
    required this.workPlace,
    required this.date,
    required this.wageRange,
    required this.contact,
    required this.category,
    required this.isCrypto,
    required this.professions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4, // Reduced elevation
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Smaller rounded corners
        ),
        child: Container(
          padding: const EdgeInsets.all(10), // Reduced padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 2, // Reduced blur radius
                offset: const Offset(0, 1), // Slightly reduced shadow position
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 4), // Reduced spacing
              Text(
                jobDescription,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12, // Reduced font size
                ),
              ),
              const SizedBox(height: 4), // Reduced spacing
              _buildInfoRow(Icons.work, 'Profession:', professions),
              _buildInfoRow(Icons.category, 'Category:', category),
              _buildInfoRow(Icons.location_on, 'Workplace:', workPlace),
              _buildInfoRow(Icons.contact_phone, 'Contact:', contact),
              _buildWageRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            jobTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18, // Slightly reduced font size
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 4), // Reduced spacing
        Text(
          date,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 11, // Reduced font size
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 3.0), // Reduced vertical padding
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 18), // Reduced icon size
          const SizedBox(width: 4), // Reduced spacing
          Text(
            '$label ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 12, // Reduced label font size
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 12, // Reduced font size
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWageRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Wage: $wageRange',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12, // Reduced font size
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            Checkbox(value: isCrypto, onChanged: null),
            const Text(
              'Crypto',
              style: TextStyle(fontSize: 12), // Reduced font size
            ),
          ],
        ),
      ],
    );
  }
}
