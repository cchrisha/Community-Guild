import 'package:community_guild/screens/completed_job.dart';
import 'package:community_guild/screens/own_post_job_detail.dart';
import 'package:community_guild/screens/pending_job_detail.dart';
import 'package:community_guild/screens/rejected_job_details.dart';
import 'package:community_guild/widget/about_job/job_card.dart';
import 'package:community_guild/widget/about_job/section_title.dart';
import 'package:flutter/material.dart';
import 'package:community_guild/screens/current_job_detail.dart';
import 'package:community_guild/screens/home.dart'; // Update import if necessary
import 'package:community_guild/screens/payment_page.dart';
import 'package:community_guild/screens/post_page.dart';
import 'package:community_guild/screens/profile_page.dart';
import 'package:community_guild/widget/about_job/completed_job_card2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/about_job/about_job_bloc.dart';
import '../bloc/about_job/about_job_state.dart';
import '../repository/all_job_detail/about_job_repository.dart';

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
      body: BlocProvider(
        create: (context) =>
            AboutJobBloc(aboutJobRepository: AboutJobRepository()),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Jobs Section
                const SectionTitleAboutJob(title: 'Current Jobs'),
                const SizedBox(height: 10),
                BlocBuilder<AboutJobBloc, AboutJobState>(
                  builder: (context, state) {
                    if (state is JobLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is JobError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else if (state is JobLoaded) {
                      return SizedBox(
                        height: 240,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.jobTitles.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: AboutJobCard(
                                  jobTitle: state.jobTitles[index],
                                  jobDescription:
                                      'Description of ${state.jobTitles[index]}',
                                  date: 'Date',
                                  workPlace: 'Workplace',
                                  wageRange: 'Wage Range',
                                  isCrypto: index % 2 == 0,
                                  professions: 'Profession',
                                  contact: 'Contact',
                                  category: 'Category',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CurrentJobDetail(
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
                      );
                    }
                    return const SizedBox();
                  },
                ),
                const SizedBox(height: 20),

                // Completed Jobs Section
                const SizedBox(height: 20),
// Completed Jobs Section
                const SectionTitleAboutJob(title: 'Completed Jobs'),
                const SizedBox(height: 10),
// Use BlocBuilder to build UI based on JobState
                BlocBuilder<AboutJobBloc, AboutJobState>(
                  builder: (context, state) {
                    if (state is JobLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is JobError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else if (state is JobLoaded) {
                      return SizedBox(
                        height: 240,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.jobTitles.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: CompletedJobCard2(
                                  jobTitle: state.jobTitles[index],
                                  jobDescription:
                                      'Description of ${state.jobTitles[index]}',
                                  workPlace: 'Workplace $index',
                                  date: 'Date $index',
                                  wageRange: 'Wage Range $index',
                                  contact: 'Contact $index',
                                  category: 'Category $index',
                                  isCrypto: index % 2 == 0,
                                  professions: 'Profession $index',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CompletedJobDetail(
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
                      );
                    }
                    return const SizedBox(); // Fallback if no state is active
                  },
                ),
                const SizedBox(height: 20),

                // Pending Jobs Section
                const SizedBox(height: 20),
// Completed Jobs Section
                const SectionTitleAboutJob(title: 'Requested Jobs'),
                const SizedBox(height: 10),
// Use BlocBuilder to build UI based on JobState
                BlocBuilder<AboutJobBloc, AboutJobState>(
                  builder: (context, state) {
                    if (state is JobLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is JobError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else if (state is JobLoaded) {
                      return SizedBox(
                        height: 240,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.jobTitles.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: CompletedJobCard2(
                                  jobTitle: state.jobTitles[index],
                                  jobDescription:
                                      'Description of ${state.jobTitles[index]}',
                                  workPlace: 'Workplace $index',
                                  date: 'Date $index',
                                  wageRange: 'Wage Range $index',
                                  contact: 'Contact $index',
                                  category: 'Category $index',
                                  isCrypto: index % 2 == 0,
                                  professions: 'Profession $index',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PendingJobDetail(
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
                      );
                    }
                    return const SizedBox(); // Fallback if no state is active
                  },
                ),
                const SizedBox(height: 20),

                // Rejected Jobs Section
                const SizedBox(height: 20),
// Completed Jobs Section
                const SectionTitleAboutJob(title: 'Rejected Jobs'),
                const SizedBox(height: 10),
// Use BlocBuilder to build UI based on JobState
                BlocBuilder<AboutJobBloc, AboutJobState>(
                  builder: (context, state) {
                    if (state is JobLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is JobError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else if (state is JobLoaded) {
                      return SizedBox(
                        height: 240,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.jobTitles.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: CompletedJobCard2(
                                  jobTitle: state.jobTitles[index],
                                  jobDescription:
                                      'Description of ${state.jobTitles[index]}',
                                  workPlace: 'Workplace $index',
                                  date: 'Date $index',
                                  wageRange: 'Wage Range $index',
                                  contact: 'Contact $index',
                                  category: 'Category $index',
                                  isCrypto: index % 2 == 0,
                                  professions: 'Profession $index',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RejectedJobDetail(
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
                      );
                    }
                    return const SizedBox(); // Fallback if no state is active
                  },
                ),
                const SizedBox(height: 20),

                const SizedBox(height: 20),
                // Posted Jobs Section
                const SectionTitleAboutJob(title: 'Posted Jobs'),
                const SizedBox(height: 10),
// Use BlocBuilder to build UI based on JobState
                BlocBuilder<AboutJobBloc, AboutJobState>(
                  builder: (context, state) {
                    if (state is JobLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is JobError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else if (state is JobLoaded) {
                      return SizedBox(
                        height: 240,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.jobTitles.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: CompletedJobCard2(
                                  jobTitle: state.jobTitles[index],
                                  jobDescription:
                                      'Description of ${state.jobTitles[index]}',
                                  workPlace: 'Workplace $index',
                                  date: 'Date $index',
                                  wageRange: 'Wage Range $index',
                                  contact: 'Contact $index',
                                  category: 'Category $index',
                                  isCrypto: index % 2 == 0,
                                  professions: 'Profession $index',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const OwnJobDetailPage(
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
                      );
                    }
                    return const SizedBox(); // Fallback if no state is active
                  },
                ),
              ],
            ),
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
