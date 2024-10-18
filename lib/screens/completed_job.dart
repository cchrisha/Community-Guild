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
    //required this.contact,
    required this.category,
  });

  final String jobTitle;
  final String jobDescription;
  final String date; // Assuming this is in ISO8601 format or similar
  final String wageRange;
  final bool isCrypto;
  final String professions;
  final String workPlace;
  //final String contact;
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
      appBar: AppBar(
        title: Text( // Remove 'const' because title is dynamic
          'Job Details',
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 180,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.lightBlueAccent, Colors.blueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(30)),
                    ),
                  ),
                  Positioned(
                    top: 28,
                    left: 16,
                    right: 16,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.lightBlueAccent,
                              child: Icon(Icons.person,
                                  color: Colors.white, size: 30),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   widget.contact, // Use contact for the poster's name
                                //   style: const TextStyle(
                                //     fontSize: 20,
                                //     fontWeight: FontWeight.bold,
                                //     color: Colors.black87,
                                //   ),
                                //   overflow: TextOverflow.ellipsis,
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.jobTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5), // Add some space between the job title and date
                  Text(
                    'Date: ${widget.date}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Description:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.jobDescription, // Dynamic job description
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 5),
              const Text(
                'Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Wage Range: ${widget.wageRange}', // Dynamic wage range
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      const Text('Crypto: '),
                      Checkbox(
                        value: widget.isCrypto, // Dynamic crypto status
                        onChanged: (bool? value) {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                'Wanted Profession: ${widget.professions}', // Dynamic professions
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Workplace: ${widget.workPlace}', // Dynamic workplace
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              // Text(
              //   'Contact: ${widget.contact}', // Dynamic contact (poster)
              //   style: const TextStyle(
              //     fontSize: 16,
              //     color: Colors.black87,
              //   ),
              // ),
              const SizedBox(height: 10),
              Text(
                'Category: ${widget.category}', // Dynamic category
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
