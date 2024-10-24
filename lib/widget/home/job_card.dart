import 'package:flutter/material.dart';

class HomeJobCard extends StatelessWidget {
  final String jobTitle;
  final String jobDescription;
  final String workPlace;
  final String date;
  final String wageRange;
  final String category;
  final bool isCrypto;
  final String professions;
  final VoidCallback onTap;

  const HomeJobCard({
    super.key,
    required this.jobTitle,
    required this.jobDescription,
    required this.workPlace,
    required this.date,
    required this.wageRange,
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
        elevation: 4, // Reduced elevation for a smaller visual effect
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12)), // Slightly reduced border radius
        child: Container(
          padding: const EdgeInsets.all(
              10), // Reduced padding for a more compact design
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1), // Lightened shadow opacity
                spreadRadius: 1,
                blurRadius: 2, // Reduced blur radius for less emphasis
                offset: const Offset(0, 1), // Reduced shadow position
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 4), // Slightly reduced vertical spacing
              Text(
                jobDescription,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12), // Reduced font size for job description
              ),
              const SizedBox(height: 4), // Reduced spacing
              _buildInfoRow(Icons.work, 'Profession:', professions),
              _buildInfoRow(Icons.category, 'Category:', category),
              _buildInfoRow(Icons.location_on, 'Workplace:', workPlace),
              const SizedBox(height: 0), // Further spacing reduction
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
              fontSize: 18, // Reduced font size for job title
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 4), // Reduced horizontal spacing
        Text(
          date,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 11, // Reduced font size for the date
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 2.0), // Reduced vertical padding
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
                  fontSize: 12), // Reduced value font size
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
              fontSize: 12, // Reduced font size for wage info
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
