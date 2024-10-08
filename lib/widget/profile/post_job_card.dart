import 'package:community_guild/screens/own_post_job_detail.dart';
import 'package:flutter/material.dart';


class PostJobCard extends StatelessWidget {
  const PostJobCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const OwnJobDetailPage(
                    jobTitle: '',
                    jobDescription: '',
                    date: '',
                    workPlace: '',
                    wageRange: '',
                    isCrypto: true,
                    professions: '',
                    contact: '',
                    category: '',
                  )),
        );
      },
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Post Job Details Here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
