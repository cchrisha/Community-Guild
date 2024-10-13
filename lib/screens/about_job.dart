import 'package:community_guild/bloc/about_job/about_job_bloc.dart';
import 'package:community_guild/bloc/about_job/about_job_event.dart';
import 'package:community_guild/bloc/about_job/about_job_state.dart';
import 'package:community_guild/repository/all_job_detail/about_job_repository.dart';
import 'package:community_guild/repository/authentication/auth_repository.dart'; // Import AuthRepository
import 'package:community_guild/screens/own_post_job_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http; // Import for Http Client

import 'package:community_guild/screens/current_job_detail.dart';
import 'package:community_guild/screens/completed_job.dart';
import 'package:community_guild/screens/pending_job_detail.dart';
import 'package:community_guild/screens/rejected_job_details.dart';
import 'package:community_guild/widget/about_job/job_card.dart';
import 'package:community_guild/widget/about_job/section_title.dart';
import 'package:community_guild/widget/about_job/completed_job_card2.dart';
import 'package:intl/intl.dart';

class JobPage extends StatelessWidget {
  const JobPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Create an instance of AuthRepository with the HTTP client
    final authRepository = AuthRepository(httpClient: http.Client());

    return BlocProvider(
      create: (context) =>
          AboutJobBloc(AboutJobRepository(authRepository: authRepository))
            ..add(FetchAboutJobsByStatus(
                'working on')), // Fetch "working on" jobs initially
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

                            // Improved function to handle date parsing and formatting
                              String formatDate(String dateString) {
                                try {
                                  // Parse the date from the string, ensure it's in ISO format
                                  DateTime parsedDate =
                                      DateTime.parse(dateString);
                                  // Format to "Month Day, Year" format (e.g., "January 10, 2024")
                                  return DateFormat('MMMM dd, yyyy')
                                      .format(parsedDate);
                                } catch (e) {
                                  return 'Invalid date'; // Return a fallback if parsing fails
                                }
                              }

                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: AboutJobCard(
                                  jobTitle: job.title,
                                  jobDescription: job.description,
                                  workPlace: job.location,
                                  date: formatDate(job.datePosted), // Apply formatted date
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
                                          date: formatDate(job.datePosted), // Apply formatted date
                                          workPlace: job.location,
                                          wageRange: job.wageRange,
                                          isCrypto: job.isCrypto,
                                          professions:
                                              job.professions.join(', '),
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
                  create: (context) => AboutJobBloc(
                      AboutJobRepository(authRepository: authRepository))
                    ..add(FetchAboutJobsByStatus(
                        'done')), // Fetch "completed" jobs
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

                              // Improved function to handle date parsing and formatting
                              String formatDate(String dateString) {
                                try {
                                  // Parse the date from the string, ensure it's in ISO format
                                  DateTime parsedDate =
                                      DateTime.parse(dateString);
                                  // Format to "Month Day, Year" format (e.g., "January 10, 2024")
                                  return DateFormat('MMMM dd, yyyy')
                                      .format(parsedDate);
                                } catch (e) {
                                  return 'Invalid date'; // Return a fallback if parsing fails
                                }
                              }

                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: CompletedJobCard2(
                                    jobTitle: job.title,
                                    jobDescription: job.description,
                                    workPlace: job.location,
                                    date: formatDate(job.datePosted), // Apply formatted date
                                    wageRange: job.wageRange,
                                    contact: job.poster.name,
                                    category: job.categories.join(', '),
                                    isCrypto: job.isCrypto,
                                    professions: job.professions.join(', '),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CompletedJobDetail(
                                            jobTitle: job.title,
                                            jobDescription: job.description,
                                            date: formatDate(job.datePosted), // Apply formatted date
                                            workPlace: job.location,
                                            wageRange: job.wageRange,
                                            isCrypto: job.isCrypto,
                                            professions:
                                                job.professions.join(', '),
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
                  create: (context) => AboutJobBloc(
                      AboutJobRepository(authRepository: authRepository))
                    ..add(FetchAboutJobsByStatus(
                        'requested')), // Fetch "requested" jobs
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

                              // Improved function to handle date parsing and formatting
                              String formatDate(String dateString) {
                                try {
                                  // Parse the date from the string, ensure it's in ISO format
                                  DateTime parsedDate =
                                      DateTime.parse(dateString);
                                  // Format to "Month Day, Year" format (e.g., "January 10, 2024")
                                  return DateFormat('MMMM dd, yyyy')
                                      .format(parsedDate);
                                } catch (e) {
                                  return 'Invalid date'; // Return a fallback if parsing fails
                                }
                              }

                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: AboutJobCard(
                                    jobTitle: job.title,
                                    jobDescription: job.description,
                                    date: formatDate(job.datePosted), // Apply formatted date
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
                                          builder: (context) =>
                                              PendingJobDetail(
                                            jobTitle: job.title,
                                            jobDescription: job.description,
                                            date: formatDate(job.datePosted), // Apply formatted date
                                            workPlace: job.location,
                                            wageRange: job.wageRange,
                                            isCrypto: job.isCrypto,
                                            professions:
                                                job.professions.join(', '),
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
                  create: (context) => AboutJobBloc(
                      AboutJobRepository(authRepository: authRepository))
                    ..add(FetchAboutJobsByStatus(
                        'rejected')), // Fetch "rejected" jobs
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

                              // Improved function to handle date parsing and formatting
                              String formatDate(String dateString) {
                                try {
                                  // Parse the date from the string, ensure it's in ISO format
                                  DateTime parsedDate =
                                      DateTime.parse(dateString);
                                  // Format to "Month Day, Year" format (e.g., "January 10, 2024")
                                  return DateFormat('MMMM dd, yyyy')
                                      .format(parsedDate);
                                } catch (e) {
                                  return 'Invalid date'; // Return a fallback if parsing fails
                                }
                              }

                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: AboutJobCard(
                                    jobTitle: job.title,
                                    jobDescription: job.description,
                                    date: formatDate(
                                        job.datePosted), // Apply formatted date
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
                                          builder: (context) =>
                                              RejectedJobDetail(
                                            jobTitle: job.title,
                                            jobDescription: job.description,
                                            date: formatDate(job
                                                .datePosted), // Apply formatted date
                                            workPlace: job.location,
                                            wageRange: job.wageRange,
                                            isCrypto: job.isCrypto,
                                            professions:
                                                job.professions.join(', '),
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

                // Posted Jobs Section
                const SectionTitleAboutJob(title: 'Posted Jobs'),
                const SizedBox(height: 10),
                FutureBuilder<String?>(
                  future: AuthRepository(httpClient: http.Client()).getUserId(), // Fetch userId asynchronously
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator()); // Show loader while waiting for userId
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Center(
                        child: Text('No User ID found. Please log in.'), // Handle null userId case
                      );
                    } else {
                      final String userId = snapshot.data!; // Extract the userId from the snapshot

                      return BlocProvider(
                        create: (context) {
                          final authRepository = AuthRepository(httpClient: http.Client());
                          final aboutJobRepository = AboutJobRepository(authRepository: authRepository);

                          return AboutJobBloc(aboutJobRepository)
                            ..add(FetchJobsPostedByUser(userId)); // Fetch jobs posted by the user
                        },
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

                                    // Improved function to handle date parsing and formatting
                                    String formatDate(String dateString) {
                                      try {
                                        DateTime parsedDate = DateTime.parse(dateString);
                                        return DateFormat('MMMM dd, yyyy').format(parsedDate);
                                      } catch (e) {
                                        return 'Invalid date'; // Fallback if parsing fails
                                      }
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.8,
                                        child: AboutJobCard(
                                          jobTitle: job.title,
                                          jobDescription: job.description,
                                          date: formatDate(job.datePosted), // Apply formatted date
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
                                                builder: (context) => OwnJobDetailPage(
                                                  jobId: job.id,
                                                  jobTitle: job.title,
                                                  jobDescription: job.description,
                                                  date: formatDate(job.datePosted),
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
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),

                // // Posted Jobs Section (Dummy Data)
                // const SectionTitleAboutJob(title: 'Posted Jobs'),
                // const SizedBox(height: 10),
                // SizedBox(
                //   height: 240,
                //   child: ListView.builder(
                //     scrollDirection: Axis.horizontal,
                //     itemCount: 5, // Dummy number of jobs
                //     itemBuilder: (context, index) {
                //       // Dummy job data
                //       final jobTitle = 'Job Title $index';
                //       final jobDescription = 'This is a description of job $index.';
                //       final datePosted = DateTime.now().subtract(Duration(days: index * 5)).toString();
                //       final workPlace = 'Location $index';
                //       final wageRange = '\$${50 + index * 10} - \$${100 + index * 10}';
                //       final contact = 'Contact Name $index';
                //       final category = 'Category $index';
                //       final isCrypto = index % 2 == 0;
                //       final professions = 'Profession $index, Profession ${index + 1}';

                //       // Date formatter function
                //       String formatDate(String dateString) {
                //         try {
                //           DateTime parsedDate = DateTime.parse(dateString);
                //           return DateFormat('MMMM dd, yyyy').format(parsedDate);
                //         } catch (e) {
                //           return 'Invalid date'; // Fallback if parsing fails
                //         }
                //       }

                //       return Padding(
                //         padding: const EdgeInsets.only(right: 10),
                //         child: SizedBox(
                //           width: MediaQuery.of(context).size.width * 0.8,
                //           child: AboutJobCard(
                //             jobTitle: jobTitle,
                //             jobDescription: jobDescription,
                //             date: formatDate(datePosted),
                //             workPlace: workPlace,
                //             wageRange: wageRange,
                //             contact: contact,
                //             category: category,
                //             isCrypto: isCrypto,
                //             professions: professions,
                //             onTap: () {
                //               // Navigate to job details page with dummy data
                //               Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                   builder: (context) => OwnJobDetailPage(
                //                     jobTitle: jobTitle,
                //                     jobDescription: jobDescription,
                //                     date: formatDate(datePosted),
                //                     wageRange: wageRange,
                //                     isCrypto: isCrypto,
                //                     professions: professions,
                //                     workPlace: workPlace,
                //                     contact: contact,
                //                     category: category,
                //                   ),
                //                 ),
                //               );
                //             },
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                // const SizedBox(height: 20),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
