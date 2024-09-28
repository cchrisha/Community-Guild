import 'package:community_guild/widget/about_job/job_card.dart';
import 'package:community_guild/widget/about_job/job_progress_bar.dart';
import 'package:community_guild/widget/about_job/section_title.dart';
import 'package:flutter/material.dart';
import 'package:community_guild/screens/current_job_detail.dart';
import 'package:community_guild/screens/home.dart';
import 'package:community_guild/screens/notif_page.dart';
import 'package:community_guild/screens/own_post_job_detail.dart';
import 'package:community_guild/screens/payment_page.dart';
import 'package:community_guild/screens/pending_job_detail.dart';
import 'package:community_guild/screens/post_page.dart';
import 'package:community_guild/screens/profile_page.dart';

class JobPage extends StatelessWidget {
  const JobPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            SizedBox(width: 16),
            Text(
              'About Job',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 3, 169, 244),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitleAboutJob(title: 'Current Job'),
              const SizedBox(height: 10),
              const JobProgressBar(),
              const SizedBox(height: 10),
              JobCardAboutJob(
                description: 'Your current job in progress here.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const CurrentJobDetailPage(), // Navigate to CurrentJobDetailPage
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const SectionTitleAboutJob(title: 'Pending Job/s'),
              const SizedBox(height: 10),
              JobCardAboutJob(
                description: 'Pending job details here.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PendingJobDetailPage(
                        jobTitle: 'Your Job Title',
                        jobDescription: 'Your Job Description',
                      ), // Navigate to PendingJobDetailPage
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const SectionTitleAboutJob(title: 'Job/s Posted'),
              const SizedBox(height: 10),
              JobCardAboutJob(
                description: 'Your Post Job Detail here.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PostJobDetail(
                        jobTitle: 'Your Job Title',
                        jobDescription: 'Your Job Description',
                      ), // Navigate to own Post
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'About Job',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment_outlined),
            label: 'Payment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.lightBlue,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
              break;
            case 1:
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PostPage()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaymentPage()),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
              break;
          }
        },
      ),
    );
  }
}
