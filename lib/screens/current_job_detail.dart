import 'package:flutter/material.dart';
import '../widget/current_job/current_info_card.dart';
import '../widget/current_job/job_action_buttons.dart';
import '../widget/current_job/job_app_bar.dart';
import '../widget/current_job/job_description_tile.dart';
import '../widget/current_job/job_photo_card.dart';
import '../widget/current_job/job_reward_text.dart';

class CurrentJobDetailPage extends StatefulWidget {
  const CurrentJobDetailPage({super.key});

  @override
  State<CurrentJobDetailPage> createState() => _CurrentJobDetailPageState();
}

class _CurrentJobDetailPageState extends State<CurrentJobDetailPage> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildJobAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CurrentInfoCard(
                  isExpanded: _isExpanded, toggleExpansion: _toggleExpansion),
              const SizedBox(height: 20),
              const JobRewardText(),
              const SizedBox(height: 10),
              const JobDescriptionTile(),
              const SizedBox(height: 20),
              const JobPhotoCard(),
              const SizedBox(height: 20),
              const JobActionButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
