import 'package:community_guild/screens/job_detail.dart';
import 'package:community_guild/screens/pending_job_detail.dart';
import 'package:community_guild/screens/post_input.dart';
import 'package:community_guild/widget/about_job/job_card.dart';
import 'package:community_guild/widget/about_job/section_title.dart';
import 'package:community_guild/widget/profile/completed_job_card.dart';
import 'package:flutter/material.dart';
import 'package:community_guild/screens/current_job_detail.dart';
import 'package:community_guild/screens/home.dart';
import 'package:community_guild/screens/notif_page.dart';
import 'package:community_guild/screens/own_post_job_detail.dart'; // Update import if necessary
import 'package:community_guild/screens/payment_page.dart';
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
              // Current Jobs Section
              const SectionTitleAboutJob(title: 'Current Jobs'),
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
                          jobTitle: 'Recommended Job Title ${index + 1}',
                          jobDescription:
                              'This is the job description for recommended job ${index + 1}.',
                          workPlace: 'Workplace ${index + 1}',
                          category: 'Category ${index + 1}',
                          date: 'Date: 2024-09-${index + 1}',
                          wageRange:
                              '\$${index * 1000 + 1000} - \$${index * 1000 + 2000}',
                          isCrypto: index % 2 == 0,
                          professions: 'Profession ${index + 1}',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const JobDetailPage(
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
                        child: AboutJobCard(
                          jobTitle: 'Recommended Job Title ${index + 1}',
                          jobDescription:
                              'This is the job description for recommended job ${index + 1}.',
                          workPlace: 'Workplace ${index + 1}',
                          category: 'Category ${index + 1}',
                          date: 'Date: 2024-09-${index + 1}',
                          wageRange:
                              '\$${index * 1000 + 1000} - \$${index * 1000 + 2000}',
                          isCrypto: index % 2 == 0,
                          professions: 'Profession ${index + 1}',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const JobDetailPage(
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
                          jobTitle: 'Recommended Job Title ${index + 1}',
                          jobDescription:
                              'This is the job description for recommended job ${index + 1}.',
                          workPlace: 'Workplace ${index + 1}',
                          category: 'Category ${index + 1}',
                          date: 'Date: 2024-09-${index + 1}',
                          wageRange:
                              '\$${index * 1000 + 1000} - \$${index * 1000 + 2000}',
                          isCrypto: index % 2 == 0,
                          professions: 'Profession ${index + 1}',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const JobDetailPage(
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
                          jobTitle: 'Recommended Job Title ${index + 1}',
                          jobDescription:
                              'This is the job description for recommended job ${index + 1}.',
                          workPlace: 'Workplace ${index + 1}',
                          category: 'Category ${index + 1}',
                          date: 'Date: 2024-09-${index + 1}',
                          wageRange:
                              '\$${index * 1000 + 1000} - \$${index * 1000 + 2000}',
                          isCrypto: index % 2 == 0,
                          professions: 'Profession ${index + 1}',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const JobDetailPage(
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
              const SectionTitleAboutJob(title: 'Jobs You Posted'),
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
                          jobTitle: 'Recommended Job Title ${index + 1}',
                          jobDescription:
                              'This is the job description for recommended job ${index + 1}.',
                          workPlace: 'Workplace ${index + 1}',
                          category: 'Category ${index + 1}',
                          date: 'Date: 2024-09-${index + 1}',
                          wageRange:
                              '\$${index * 1000 + 1000} - \$${index * 1000 + 2000}',
                          isCrypto: index % 2 == 0,
                          professions: 'Profession ${index + 1}',
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
                MaterialPageRoute(builder: (context) => const PostInput()),
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
