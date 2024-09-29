import 'package:flutter/material.dart';
import '../widget/pending_job/job_description_tile.dart';
import '../widget/pending_job/job_photo_card.dart';
import '../widget/pending_job/pending_info_card.dart';
import '../widget/pending_job/pending_job_actions.dart';
import '../widget/pending_job/pending_job_app_bar.dart';

class PendingJobDetailPage extends StatefulWidget {
  const PendingJobDetailPage({
    super.key,
    required this.jobTitle,
    required this.jobDescription,
  });

  final String jobTitle;
  final String jobDescription;

  @override
  State<PendingJobDetailPage> createState() => _PendingJobDetailPageState();
}

class _PendingJobDetailPageState extends State<PendingJobDetailPage> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _cancelJob() {
    // Implement cancel job logic
    Navigator.pop(context); // Example action to go back
  }

  void _startJob() {
    // Implement start job logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PendingJobAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                child: Stack(
                  children: [
                    Positioned(
                      top: 28,
                      left: 16,
                      right: 16,
                      child: PendingInfoCard(
                        isExpanded: _isExpanded,
                        toggleExpansion: _toggleExpansion,
                      ),
                    ),
                  ],
                ),
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
              const JobDescriptionTile(),
              const SizedBox(height: 20),
              const JobPhotoCard(),
              const SizedBox(height: 20),
              PendingJobButtons(
                onCancel: _cancelJob,
                onStart: _startJob,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
