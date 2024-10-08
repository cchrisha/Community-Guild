import 'package:community_guild/screens/completed_job.dart';
import 'package:community_guild/screens/job_detail.dart';
import 'package:community_guild/screens/pending_job_detail.dart';
import 'package:community_guild/screens/rejected_job_details.dart';
import 'package:community_guild/widget/about_job/job_card.dart';
import 'package:community_guild/widget/about_job/post_job_card2.dart';
import 'package:community_guild/widget/about_job/section_title.dart';
import 'package:flutter/material.dart';
import 'package:community_guild/screens/current_job_detail.dart';
import 'package:community_guild/screens/home.dart';
import 'package:community_guild/screens/notif_page.dart';
import 'package:community_guild/screens/own_post_job_detail.dart'; // Update import if necessary
import 'package:community_guild/screens/payment_page.dart';
import 'package:community_guild/screens/post_page.dart';
import 'package:community_guild/screens/profile_page.dart';
import 'package:community_guild/widget/about_job/completed_job_card2.dart';

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
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Jobs Section
              const SectionTitleAboutJob(title: 'Current Jobs'),
              const SizedBox(height: 10),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.8, //responsive na width
                        child: AboutJobCard(
                          jobTitle: 'Job Title $index', // Replace with actual data
                          jobDescription: 'Description of job $index', // Replace with actual data
                          workPlace: 'Workplace $index', // Replace with actual data
                          date: 'Date $index', // Replace with actual data
                          wageRange: 'Wage Range $index', // Replace with actual data
                          contact: 'Contact $index', // Replace with actual data
                          category: 'Category $index', // Replace with actual data
                          isCrypto: index % 2 == 0, // Replace with actual data
                          professions: 'Profession $index', // Replace with actual data
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CurrentJobDetail(
                                  jobTitle: '',
                                  jobDescription: '',
                                  date: '',
                                  workPlace: '',
                                  wageRange: '',
                                  isCrypto: true,
                                  professions: '',
                                  contact: '',
                                  category: '',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Completed Jobs Section
              const SectionTitleAboutJob(title: 'Completed Jobs'),
              const SizedBox(height: 10),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.8, //responsive na width
                        child: CompletedJobCard2(
                          jobTitle: 'Job Title $index', // Replace with actual data
                          jobDescription: 'Description of job $index', // Replace with actual data
                          workPlace: 'Workplace $index', // Replace with actual data
                          date: 'Date $index', // Replace with actual data
                          wageRange: 'Wage Range $index', // Replace with actual data
                          contact: 'Contact $index', // Replace with actual data
                          category: 'Category $index', // Replace with actual data
                          isCrypto: index % 2 == 0, // Replace with actual data
                          professions: 'Profession $index', // Replace with actual data
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CompletedJobDetail(
                                  jobTitle: '',
                                  jobDescription: '',
                                  date: '',
                                  workPlace: '',
                                  wageRange: '',
                                  isCrypto: true,
                                  professions: '',
                                  contact: '',
                                  category: '',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Pending Jobs Section
              const SectionTitleAboutJob(title: 'Pending Jobs'),
              const SizedBox(height: 10),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.8, //responsive na width
                        child: AboutJobCard(
                          jobTitle: 'Job Title $index', // Replace with actual data
                          jobDescription: 'Description of job $index', // Replace with actual data
                          date: 'Date $index', // Replace with actual data
                          workPlace: 'Workplace $index', // Replace with actual data
                          wageRange: 'Wage Range $index', // Replace with actual data
                          isCrypto: index % 2 == 0, // Replace with actual data
                          professions: 'Profession $index', // Replace with actual data
                          contact: 'Contact $index', // Replace with actual data
                          category: 'Category $index', // Replace with actual data
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PendingJobDetail(
                                  jobTitle: '',
                                  jobDescription: '',
                                  date: '',
                                  workPlace: '',
                                  wageRange: '',
                                  isCrypto: true,
                                  professions: '',
                                  contact: '',
                                  category: '',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Rejected Jobs Section
              const SectionTitleAboutJob(title: 'Rejected Jobs'),
              const SizedBox(height: 10),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.8, //responsive na width
                        child: AboutJobCard(
                          jobTitle: 'Job Title $index', // Replace with actual data
                          jobDescription: 'Description of job $index', // Replace with actual data
                          date: 'Date $index', // Replace with actual data
                          workPlace: 'Workplace $index', // Replace with actual data
                          wageRange: 'Wage Range $index', // Replace with actual data
                          isCrypto: index % 2 == 0, // Replace with actual data
                          professions: 'Profession $index', // Replace with actual data
                          contact: 'Contact $index', // Replace with actual data
                          category: 'Category $index', // Replace with actual data
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RejectedJobDetail(
                                  jobTitle: '',
                                  jobDescription: '',
                                  date: '',
                                  workPlace: '',
                                  wageRange: '',
                                  isCrypto: true,
                                  professions: '',
                                  contact: '',
                                  category: '',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Jobs You Posted Section
              const SectionTitleAboutJob(title: 'Posted Jobs'),
              const SizedBox(height: 10),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.8, //responsive na width
                        child: PostedJobCard2(
                          jobTitle: 'Job Title $index', // Replace with actual data
                          jobDescription: 'Description of job $index', // Replace with actual data
                          workPlace: 'Workplace $index', // Replace with actual data
                          date: 'Date $index', // Replace with actual data
                          wageRange: 'Wage Range $index', // Replace with actual data
                          contact: 'Contact $index', // Replace with actual data
                          category: 'Category $index', // Replace with actual data
                          isCrypto: index % 2 == 0, // Replace with actual data
                          professions: 'Profession $index', // Replace with actual data
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
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
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
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.black,
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
