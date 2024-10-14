import 'package:community_guild/bloc/about_job/about_job_bloc.dart';
import 'package:community_guild/bloc/about_job/about_job_event.dart';
import 'package:community_guild/bloc/about_job/about_job_state.dart';
import 'package:community_guild/repository/all_job_detail/about_job_repository.dart';
import 'package:community_guild/repository/authentication/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http; // Required for the repository

class OwnJobDetailPage extends StatefulWidget {
  const   OwnJobDetailPage({
    super.key,
    required this.jobId,
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

  final String jobId; // Add jobId parameter here
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

//ito yung requssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
  void _showApplicantsDialog(String jobId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider(
        create: (context) => AboutJobBloc(
          AboutJobRepository(authRepository: AuthRepository(httpClient: http.Client()))
        )..add(FetchJobApplicants(jobId)),
        child: BlocBuilder<AboutJobBloc, AboutJobState>(
          builder: (context, state) {
            if (state is AboutJobApplicantsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AboutJobApplicantsLoaded) {
              return _buildApplicantsDialog(state.applicants);
            } else if (state is AboutJobApplicantsError) {
              return _buildErrorDialog(state.message);
            }
            return const SizedBox.shrink(); // Placeholder for initial state
          },
        ),
      );
    },
  );
}

Widget _buildApplicantsDialog(List<String> applicants) {
  // Print the list of applicants to the terminal
  print('Applicants: ${applicants.join(', ')}');

  return AlertDialog(
    title: const Text('Applicants'),
    content: SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: applicants.map((applicant) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.lightBlueAccent,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(applicant)), // Display the applicant name
                  ElevatedButton(
                    onPressed: () {
                      context.read<AboutJobBloc>().add(AcceptApplicantEvent(widget.jobId, applicant));
                    },
                    child: const Text('Accept'),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    ),
    actions: [
      ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Close'),
      ),
    ],
  );
}

Widget _buildErrorDialog(String message) {
  return AlertDialog(
    title: const Text('Error'),
    content: Text(message),
    actions: [
      ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Close'),
      ),
    ],
  );
}


//ito yung workerssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss

  void _showWorkersDialog(String jobId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider(
        create: (context) => AboutJobBloc(
          AboutJobRepository(authRepository: AuthRepository(httpClient: http.Client())),
        )..add(FetchJobWorkers(jobId)),
        child: BlocBuilder<AboutJobBloc, AboutJobState>(
          builder: (context, state) {
            if (state is AboutJobWorkersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AboutJobWorkersLoaded) {
              return _buildWorkersDialog(state.workers);
            } else if (state is AboutJobWorkersError) {
              return _buildErrorDialog(state.message);
            }
            return const SizedBox.shrink(); // Placeholder for initial state
          },
        ),
      );
    },
  );
}

Widget _buildWorkersDialog(List<String> workers) {
  // Print the list of workers to the terminal
  print('Workers: ${workers.join(', ')}');

  return AlertDialog(
    title: const Text('Workers'),
    content: SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: workers.map((worker) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.lightBlueAccent,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(worker)), // Display the worker name
                  ElevatedButton(
                    onPressed: () {
                      context.read<AboutJobBloc>().add(MarkWorkerDoneEvent(widget.jobId, worker));
                    },
                    child: const Text('Done'),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    ),
    actions: [
      ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Close'),
      ),
    ],
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
                        child: Row(
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
                                  widget.contact,
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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Title: ${widget.jobTitle}',
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
                'Description:',
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
                    'Wage Range: ${widget.wageRange}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      const Text('Crypto: '),
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     SizedBox(
              //       width: 120, // Set a specific width for consistency
              //       child: ElevatedButton(
              //         onPressed: () {
              //           // Add your edit logic here
              //         },
              //         child: const Text('Edit'),
              //       ),
              //     ),
              //     SizedBox(
              //       width: 120, // Same width as the Edit button
              //       child: ElevatedButton(
              //         onPressed: () {
              //           // Add your delete logic here
              //         },
              //         child: const Text('Delete'),
              //       ),
              //     ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 120, // Same width as the View Applicants button
                    child: ElevatedButton(
                      onPressed: () => _showApplicantsDialog(widget.jobId), // Pass jobId from the widget
                      child: const Center(
                        child: Text('Applicants'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 120, // Set button width
                    child: ElevatedButton(
                      onPressed: () => _showWorkersDialog(widget.jobId), // Pass jobId from the widget
                      child: const Center(
                        child: Text('Workers'),
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
