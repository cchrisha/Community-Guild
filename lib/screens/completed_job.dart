import 'package:flutter/material.dart';
import '../widget/complete_job/complete_info_card.dart';
import '../widget/complete_job/completed_job_app_bar.dart';
import '../widget/complete_job/job_description.dart';
import '../widget/complete_job/image_list.dart';

class CompletedJob extends StatefulWidget {
  const CompletedJob({
    super.key,
    required this.jobTitle,
    required this.jobDescription,
  });

  final String jobTitle;
  final String jobDescription;

  @override
  State<CompletedJob> createState() => _CompletedJobState();
}

class _CompletedJobState extends State<CompletedJob> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CompletedJobAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CompleteInfoCard(
                isExpanded: _isExpanded,
                toggleExpansion: _toggleExpansion,
              ),
              const SizedBox(height: 20),
              const Text(
                'Reward: P1000.00',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const JobDescription(),
              const SizedBox(height: 20),
              const ImageList(),
            ],
          ),
        ),
      ),
    );
  }
}
