import 'package:flutter/material.dart';

class OwnJobDetailPage extends StatefulWidget {
  const OwnJobDetailPage({
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
  final String date;
  final String wageRange;
  final bool isCrypto;
  final String professions;
  final String workPlace;
  final String contact;
  final String category;

  @override
  State<OwnJobDetailPage> createState() => _OwnJobDetailPageState();
}

class _OwnJobDetailPageState extends State<OwnJobDetailPage> {
  // Mock data for Request and Workers dialogs
  final List<String> users = ['User 1', 'User 2', 'User 3', 'User 4', 'User 5', 'User 6', 'User 7']; // Sample larger list

//ito yung workerssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
  void _showApplicantsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Applicants'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9, // Adjust width
            child: SingleChildScrollView( // Scrollable content for large lists
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: users.map((user) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical:3.0), // Adjust vertical space
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.lightBlueAccent,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Expanded( // Ensure name takes available space
                          child: Text(user),
                        ),
                        const Spacer(), // Space between name and buttons
                        ElevatedButton(
                          onPressed: () {
                            // Add logic
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Decrease padding
                            minimumSize: const Size(50, 30), // Set minimum size
                            textStyle: const TextStyle(fontSize: 12), // Decrease font size
                          ),
                          child: const Text('Add'),
                        ),
                        const SizedBox(width: 5), // Space between buttons
                        ElevatedButton(
                          onPressed: () {
                            // Remove logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Decrease padding
                            minimumSize: const Size(50, 30), // Set minimum size
                            textStyle: const TextStyle(fontSize: 12), // Decrease font size
                          ),
                          child: const Text('Remove'),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.all(10), // Adjust padding for actions
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Decrease padding
                minimumSize: const Size(50, 30), // Set minimum size
                textStyle: const TextStyle(fontSize: 12), // Decrease font size
              ),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

//ito yung requestsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss

  void _showWorkersDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Workers'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9, // Adjust width
            child: SingleChildScrollView( // Scrollable content for large lists
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: users.map((user) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjust vertical space
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.lightBlueAccent,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(user),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.all(10), // Adjust padding for actions
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Decrease padding
                minimumSize: const Size(50, 30), // Set minimum size
                textStyle: const TextStyle(fontSize: 12), // Decrease font size
              ),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }


//anditoooooooooooooooooooooooooooo yung name title description emeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Job Details',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                        padding: const EdgeInsets.all(16), // Add padding
                        child: const Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.lightBlueAccent,
                              child: Icon(Icons.person,
                                  color: Colors.white, size: 30),
                            ),
                            SizedBox(
                                width: 16), // Spacing between avatar and text
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Job Title: ${widget.jobTitle}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
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
                'Job Description:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.jobDescription,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 5),
              const Text(
                'More Info',
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
                    'Wage Range: ${widget.wageRange}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      const Text('Is Crypto: '),
                      Checkbox(
                        value: widget.isCrypto,
                        onChanged: (bool? value) {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                'Wanted Profession: ${widget.professions}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Workplace: ${widget.workPlace}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Contact: ${widget.contact}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Category: ${widget.category}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              
//ito yung mga butoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooons

              // Buttons section below all elements
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 120, // Set a specific width for consistency
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your edit logic here
                      },
                      child: const Text('Edit'),
                    ),
                  ),
                  SizedBox(
                    width: 120, // Same width as the Edit button
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your delete logic here
                      },
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 120, // Same width as the View Applicants button
                    child: ElevatedButton(
                      onPressed: _showApplicantsDialog,
                      child: const Center(
                        child: Text('View Applicants'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 120, // Same width as the View Applicants button
                    child: ElevatedButton(
                      onPressed: _showWorkersDialog,
                      child: const Center(
                        child: Text('View Workers'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
