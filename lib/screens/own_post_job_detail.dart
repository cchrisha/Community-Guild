import 'package:flutter/material.dart';
import '../widget/own_post_job/image_list.dart';
import '../widget/own_post_job/job_description_tile.dart';
import '../widget/own_post_job/post_job_appbar.dart';
import '../widget/own_post_job/reward_text.dart';
import '../widget/own_post_job/user_card.dart';

class PostJobDetail extends StatefulWidget {
  const PostJobDetail({
    super.key,
    required this.jobTitle,
    required this.jobDescription,
  });

  final String jobTitle;
  final String jobDescription;

  @override
  State<PostJobDetail> createState() => _PostJobDetailState();
}

class _PostJobDetailState extends State<PostJobDetail> {
  bool _isExpanded = false;

  void onSelected(BuildContext context, int item) {}

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PostJobAppBar(onSelected: (item) => onSelected(context, item)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserCard(
                isExpanded: _isExpanded,
                onToggleExpansion: _toggleExpansion,
              ),
              const SizedBox(height: 20),
              const RewardText(),
              const SizedBox(height: 10),
              const JobDescriptionTile(),
              const SizedBox(height: 20),
              const ImageList(),
            ],
          ),
        ),
      ),
    );
  }
}
