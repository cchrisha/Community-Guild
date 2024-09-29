import 'package:flutter/material.dart';
import '../widget/job_detail_on_home/job_app_bar.dart';
import '../widget/job_detail_on_home/user_info_card.dart';
import '../widget/job_detail_on_home/job_description.dart';
import '../widget/job_detail_on_home/image_list.dart';
import '../widget/job_detail_on_home/action_buttons.dart';

class JobDetailPage extends StatefulWidget {
  const JobDetailPage({
    super.key,
    required this.jobTitle,
    required this.jobDescription,
  });

  final String jobTitle;
  final String jobDescription;

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JobAppBar(onBackPressed: () => Navigator.pop(context)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfoCard(isExpanded: _isExpanded, onToggle: _toggleExpansion),
              const SizedBox(height: 20),
              JobDescription(description: widget.jobDescription),
              const SizedBox(height: 20),
              const ImageList(),
              const SizedBox(height: 20),
              ActionButtons(onCancel: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}
