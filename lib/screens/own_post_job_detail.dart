import 'package:community_guild/bloc/about_job/about_job_bloc.dart';
import 'package:community_guild/bloc/about_job/about_job_event.dart';
import 'package:community_guild/bloc/about_job/about_job_state.dart';
import 'package:community_guild/repository/all_job_detail/about_job_repository.dart';
import 'package:community_guild/repository/authentication/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http; // Required for the repository
import 'dart:convert';

import '../widget/loading_widget/ink_drop.dart'; // Ensure you have this import for json.encode

class OwnJobDetailPage extends StatefulWidget {
  const OwnJobDetailPage({
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
  final List<String> users = [
    'User 1',
    'User 2',
    'User 3',
    'User 4',
    'User 5',
    'User 6',
    'User 7'
  ]; // Sample larger list

  // Add your authRepository as a member of the state class
  final AuthRepository authRepository =
      AuthRepository(httpClient: http.Client());

  // Method to update job request status
  Future<void> updateJobRequestStatus(
      String jobId, String userId, String action) async {
    try {
      String? token = await authRepository.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No valid token found. Please login again.');
      }

      final response = await http.put(
        Uri.parse(
            'https://api-tau-plum.vercel.app/api/jobs/$jobId/request/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'action': action, // 'accept' or 'reject'
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update job request status.');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> updateWorkerStatus(
      String jobId, String userId, String action) async {
    try {
      String? token = await authRepository.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No valid token found. Please login again.');
      }

      final response = await http.put(
        Uri.parse(
            'https://api-tau-plum.vercel.app/api/jobs/$jobId/workers/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'action': action, // 'done' or 'canceled'
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update worker status.');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

//ito yung requssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
  void _showApplicantsDialog(String jobId) {
    print(
        'Showing applicants for Job ID: $jobId'); // Print jobId when showing the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => AboutJobBloc(AboutJobRepository(
              authRepository: AuthRepository(httpClient: http.Client())))
            ..add(FetchJobApplicants(jobId)),
          child: BlocBuilder<AboutJobBloc, AboutJobState>(
            builder: (context, state) {
              if (state is AboutJobApplicantsLoading) {
                return  Center(
                  child: InkDrop(
                    size: 40,
                    color: Colors.lightBlue,
                    ringColor: Colors.lightBlue.withOpacity(0.2),
                  ),
                );
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

  Widget _buildApplicantsDialog(List<Map<String, String>> applicants) {
    return AlertDialog(
      title: const Text('Applicants'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: applicants.map((applicant) {
              String applicantName = applicant['name'] ?? 'Unknown';
              String userId = applicant['userId']!; // Get userId

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.lightBlueAccent,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(applicantName,
                                style: const TextStyle(fontSize: 16))),
                      ],
                    ),
                    const SizedBox(
                        height: 10), // Space between name and buttons

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Accept Button
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              // Call the updateJobRequestStatus method to accept the applicant
                              await updateJobRequestStatus(
                                  widget.jobId, userId, 'accept');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Applicant accepted successfully.')),
                              );
                            } catch (e) {
                              // Handle error and show error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          },
                          child: const Text('Accept'),
                        ),

                        // Reject Button
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              // Call the updateJobRequestStatus method to reject the applicant
                              await updateJobRequestStatus(
                                  widget.jobId, userId, 'reject');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Applicant rejected successfully.')),
                              );
                            } catch (e) {
                              // Handle error and show error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          },
                          child: const Text('Reject'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .redAccent, // Set button color to red for Reject
                          ),
                        ),
                      ],
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
            AboutJobRepository(
                authRepository: AuthRepository(httpClient: http.Client())),
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

  Widget _buildWorkersDialog(List<Map<String, String>> workers) {
    return AlertDialog(
      title: const Text('Workers'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: workers.map((worker) {
              String workerName = worker['name'] ?? 'Unknown';
              String userId = worker['userId']!; // Get worker's userId

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.lightBlueAccent,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(workerName)), // Display the worker's name
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          // Call the updateWorkerStatus method to mark the worker as done
                          await updateWorkerStatus(
                              widget.jobId, userId, 'done');
                          // Optionally, show a success message or refresh the state
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Worker marked as done.')),
                          );
                        } catch (e) {
                          // Handle error and show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
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
              Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.work, size: 30, color: Color(0xFF03A9F4)),
                      SizedBox(width: 90),
                      Icon(Icons.location_on, size: 30, color: Color(0xFF03A9F4)),
                      SizedBox(width: 90),
                      Icon(Icons.monetization_on, size: 30, color: Color(0xFF03A9F4),),
                    ],
                  ),
                  const SizedBox(height: 10), // Space between icon row and data row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.professions,
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.workPlace,
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "${widget.wageRange} (${widget.isCrypto ? 'Crypto' : 'Not Crypto'})",
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // Action Buttons (Applicants and Workers)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 130,
                    child: ElevatedButton(
                      onPressed: () => _showApplicantsDialog(widget.jobId),
                      child: const Text(
                        'Applicants',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15,),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  SizedBox(
                    width: 130,
                    child: ElevatedButton(
                      onPressed: () => _showWorkersDialog(widget.jobId),
                      child: const Text(
                        'Workers',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
               Center(
              child: SizedBox(
                width: 290,
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
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15,),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
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
      ),
    );
  }
  Widget _buildDetailIcon(IconData icon, String data) {
    return Column(
      children: [
        Icon(icon, size: 30, color: const Color(0xFF03A9F4)), // Icon with fixed size
        const SizedBox(height: 10), // Space between the icon and text
        SizedBox(
          width: 80, // Fixed width for the text under the icon
          child: Text(
            data.isNotEmpty ? data : (icon == Icons.money_off ? 'Not Crypto' : 'Crypto'),
            style: const TextStyle(fontSize: 16, color: Color.fromARGB(137, 0, 0, 0)),
            maxLines: 3, // Limit the text to 3 lines
            softWrap: true, // Allow text to wrap within the fixed width
            overflow: TextOverflow.ellipsis, // Add ellipsis if text exceeds 3 lines
            textAlign: TextAlign.center, // Center-align the text under the icon
          ),
        ),
      ],
    );
  }

}
