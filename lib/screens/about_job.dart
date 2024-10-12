import 'package:community_guild/bloc/about_job/about_job_bloc.dart';
import 'package:community_guild/bloc/about_job/about_job_event.dart';
import 'package:community_guild/bloc/about_job/about_job_state.dart';
import 'package:community_guild/repository/all_job_detail/about_job_repository.dart';
import 'package:community_guild/repository/authentication/auth_repository.dart'; // Import AuthRepository
import 'package:community_guild/repository/authentication/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http; // Import for Http Client

import 'package:community_guild/screens/current_job_detail.dart';
import 'package:community_guild/screens/completed_job.dart';
import 'package:community_guild/screens/pending_job_detail.dart';
import 'package:community_guild/screens/rejected_job_details.dart';
import 'package:community_guild/screens/own_post_job_detail.dart';
import 'package:community_guild/screens/home.dart';
import 'package:community_guild/screens/payment_page.dart';
import 'package:community_guild/screens/post_input.dart';
import 'package:community_guild/screens/profile_page.dart';
import 'package:community_guild/widget/about_job/job_card.dart';
import 'package:community_guild/widget/about_job/section_title.dart';
import 'package:community_guild/widget/about_job/completed_job_card2.dart';

class JobPage extends StatelessWidget {
  const JobPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Create an instance of AuthRepository with the HTTP client
    final authRepository = AuthRepository(httpClient: http.Client());

    return BlocProvider(
      create: (context) => AboutJobBloc(AboutJobRepository(authRepository: authRepository))
        ..add(FetchAboutJobsByStatus('working on')), // Fetch "working on" jobs initially
      child: Scaffold(
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
                BlocBuilder<AboutJobBloc, AboutJobState>(
                  builder: (context, state) {
                    if (state is AboutJobLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is AboutJobLoaded) {
                      return SizedBox(
                        height: 240,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.jobs.length,
                          itemBuilder: (context, index) {
                            final job = state.jobs[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: AboutJobCard(
                                  jobTitle: job.title,
                                  jobDescription: job.description,
                                  workPlace: job.location,
                                  date: job.datePosted,
                                  wageRange: job.wageRange,
                                  contact: job.poster.name,
                                  category: job.categories.join(', '),
                                  isCrypto: job.isCrypto,
                                  professions: job.professions.join(', '),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CurrentJobDetail(
                                          jobTitle: job.title,
                                          jobDescription: job.description,
                                          date: job.datePosted,
                                          workPlace: job.location,
                                          wageRange: job.wageRange,
                                          isCrypto: job.isCrypto,
                                          professions: job.professions.join(', '),
                                          contact: job.poster.name,
                                          category: job.categories.join(', '),
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
                    } else if (state is AboutJobError) {
                      return Center(
                        child: Text('Error: ${state.message}'),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const SizedBox(height: 20),

                // Completed Jobs Section
                const SectionTitleAboutJob(title: 'Completed Jobs'),
                const SizedBox(height: 10),
                BlocProvider(
                  create: (context) => AboutJobBloc(AboutJobRepository(authRepository: authRepository))
                    ..add(FetchAboutJobsByStatus('done')), // Fetch "completed" jobs
                  child: BlocBuilder<AboutJobBloc, AboutJobState>(
                    builder: (context, state) {
                      if (state is AboutJobLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is AboutJobLoaded) {
                        return SizedBox(
                          height: 240,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.jobs.length,
                            itemBuilder: (context, index) {
                              final job = state.jobs[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: CompletedJobCard2(
                                    jobTitle: job.title,
                                    jobDescription: job.description,
                                    workPlace: job.location,
                                    date: job.datePosted,
                                    wageRange: job.wageRange,
                                    contact: job.poster.name,
                                    category: job.categories.join(', '),
                                    isCrypto: job.isCrypto,
                                    professions: job.professions.join(', '),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CompletedJobDetail(
                                            jobTitle: job.title,
                                            jobDescription: job.description,
                                            date: job.datePosted,
                                            workPlace: job.location,
                                            wageRange: job.wageRange,
                                            isCrypto: job.isCrypto,
                                            professions: job.professions.join(', '),
                                            contact: job.poster.name,
                                            category: job.categories.join(', '),
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
                      } else if (state is AboutJobError) {
                        return Center(
                          child: Text('Error: ${state.message}'),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Pending Jobs Section
                const SectionTitleAboutJob(title: 'Requested Jobs'),
                const SizedBox(height: 10),
                BlocProvider(
                  create: (context) => AboutJobBloc(AboutJobRepository(authRepository: authRepository))
                    ..add(FetchAboutJobsByStatus('requested')), // Fetch "requested" jobs
                  child: BlocBuilder<AboutJobBloc, AboutJobState>(
                    builder: (context, state) {
                      if (state is AboutJobLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is AboutJobLoaded) {
                        return SizedBox(
                          height: 240,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.jobs.length,
                            itemBuilder: (context, index) {
                              final job = state.jobs[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: AboutJobCard(
                                    jobTitle: job.title,
                                    jobDescription: job.description,
                                    date: job.datePosted,
                                    workPlace: job.location,
                                    wageRange: job.wageRange,
                                    contact: job.poster.name,
                                    category: job.categories.join(', '),
                                    isCrypto: job.isCrypto,
                                    professions: job.professions.join(', '),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PendingJobDetail(
                                            jobTitle: job.title,
                                            jobDescription: job.description,
                                            date: job.datePosted,
                                            workPlace: job.location,
                                            wageRange: job.wageRange,
                                            isCrypto: job.isCrypto,
                                            professions: job.professions.join(', '),
                                            contact: job.poster.name,
                                            category: job.categories.join(', '),
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
                      } else if (state is AboutJobError) {
                        return Center(
                          child: Text('Error: ${state.message}'),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Rejected Jobs Section
                const SectionTitleAboutJob(title: 'Rejected Jobs'),
                const SizedBox(height: 10),
                BlocProvider(
                  create: (context) => AboutJobBloc(AboutJobRepository(authRepository: authRepository))
                    ..add(FetchAboutJobsByStatus('rejected')), // Fetch "rejected" jobs
                  child: BlocBuilder<AboutJobBloc, AboutJobState>(
                    builder: (context, state) {
                      if (state is AboutJobLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is AboutJobLoaded) {
                        return SizedBox(
                          height: 240,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.jobs.length,
                            itemBuilder: (context, index) {
                              final job = state.jobs[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: AboutJobCard(
                                    jobTitle: job.title,
                                    jobDescription: job.description,
                                    date: job.datePosted,
                                    workPlace: job.location,
                                    wageRange: job.wageRange,
                                    contact: job.poster.name,
                                    category: job.categories.join(', '),
                                    isCrypto: job.isCrypto,
                                    professions: job.professions.join(', '),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RejectedJobDetail(
                                            jobTitle: job.title,
                                            jobDescription: job.description,
                                            date: job.datePosted,
                                            workPlace: job.location,
                                            wageRange: job.wageRange,
                                            isCrypto: job.isCrypto,
                                            professions: job.professions.join(', '),
                                            contact: job.poster.name,
                                            category: job.categories.join(', '),
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
                      } else if (state is AboutJobError) {
                        return Center(
                          child: Text('Error: ${state.message}'),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
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
      ),
    );
  }
}
