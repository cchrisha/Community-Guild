import 'package:community_guild/bloc/about_job/about_job_bloc.dart';
import 'package:community_guild/bloc/about_job/about_job_event.dart';
import 'package:community_guild/bloc/about_job/about_job_state.dart';
import 'package:community_guild/repository/all_job_detail/about_job_repository.dart';
import 'package:community_guild/repository/authentication/auth_repository.dart';
import 'package:community_guild/screens/own_post_job_detail.dart';
import 'package:community_guild/screens/requested_job.dart';
import 'package:community_guild/widget/about_job/posted_job_card.dart';
import 'package:community_guild/widget/about_job/rejected_card.dart';
import 'package:community_guild/widget/about_job/requested_job_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:community_guild/screens/current_job_detail.dart';
import 'package:community_guild/screens/completed_job.dart';
import 'package:community_guild/screens/rejected_job_details.dart';
import 'package:community_guild/widget/about_job/current_job_card.dart';
import 'package:community_guild/widget/about_job/section_title.dart';
import 'package:community_guild/widget/about_job/completed_job_card.dart';
import 'package:intl/intl.dart';

import '../widget/loading_widget/progressive_dots.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key});

  @override
  _JobPageState createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  bool _isCurrentJobsExpanded = false;
  bool _isCompletedJobsExpanded = false;
  bool _isRequestedJobsExpanded = false;
  bool _isRejectedJobsExpanded = false;
  bool _isPostedJobsExpanded = false;

  void _toggleSection(String section) {
    setState(() {
      _isCurrentJobsExpanded =
          section == 'current' ? !_isCurrentJobsExpanded : false;
      _isCompletedJobsExpanded =
          section == 'completed' ? !_isCompletedJobsExpanded : false;
      _isRequestedJobsExpanded =
          section == 'requested' ? !_isRequestedJobsExpanded : false;
      _isRejectedJobsExpanded =
          section == 'rejected' ? !_isRejectedJobsExpanded : false;
      _isPostedJobsExpanded =
          section == 'posted' ? !_isPostedJobsExpanded : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository(httpClient: http.Client());

    return BlocProvider(
      create: (context) =>
          AboutJobBloc(AboutJobRepository(authRepository: authRepository))
            ..add(FetchAboutJobsByStatus('working on')), // Fetch jobs
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
                SectionTitleAboutJob(
                    title: 'Current Jobs',
                    isExpanded: _isCurrentJobsExpanded,
                    onTap: () {
                      _toggleSection('current');
                    }),
                const SizedBox(height: 0),
                BlocBuilder<AboutJobBloc, AboutJobState>(
                  builder: (context, state) {
                    if (state is AboutJobLoading) {
                      return const Center(
                        child: ProgressiveDots(
                          color: Colors.blue,
                          size: 40.0, // Customize the size as per your need
                        ),
                      );
                    } else if (state is AboutJobLoaded) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        constraints: BoxConstraints(
                          maxHeight: _isCurrentJobsExpanded ? 230 : 0,
                        ),
                        child: ClipRect(
                          child: OverflowBox(
                            maxHeight: _isCurrentJobsExpanded ? 230 : 0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: state.jobs.length,
                              itemBuilder: (context, index) {
                                final job = state.jobs[index];

                                // Function to handle date parsing and formatting
                                String formatDate(String dateString) {
                                  try {
                                    DateTime parsedDate =
                                        DateTime.parse(dateString);
                                    return DateFormat('MMMM dd, yyyy')
                                        .format(parsedDate);
                                  } catch (e) {
                                    return 'Invalid date'; // Return a fallback if parsing fails
                                  }
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(right: 0),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: CurrentJobCard(
                                      jobTitle: job.title,
                                      jobDescription: job.description,
                                      workPlace: job.location,
                                      date: formatDate(job.datePosted),
                                      wageRange: job.wageRange,
                                      // contact: job.poster.name,
                                      category: job.categories.join(', '),
                                      isCrypto: job.isCrypto,
                                      professions: job.professions.join(', '),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CurrentJobDetail(
                                              jobTitle: job.title,
                                              jobDescription: job.description,
                                              date: formatDate(job.datePosted),
                                              workPlace: job.location,
                                              wageRange: job.wageRange,
                                              isCrypto: job.isCrypto,
                                              professions:
                                                  job.professions.join(', '),
                                              contact: job.poster.name,
                                              category:
                                                  job.categories.join(', '),
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
                const SizedBox(height: 10),
                SectionTitleAboutJob(
                  title: 'Completed Jobs',
                  isExpanded: _isCompletedJobsExpanded,
                  onTap: () {
                    _toggleSection('completed');
                  },
                ),
                BlocProvider(
                  create: (context) => AboutJobBloc(
                      AboutJobRepository(authRepository: authRepository))
                    ..add(FetchAboutJobsByStatus('done')),
                  child: BlocBuilder<AboutJobBloc, AboutJobState>(
                    builder: (context, state) {
                      if (state is AboutJobLoading) {
                        return const Center(
                          child: ProgressiveDots(
                            color: Colors.blue,
                            size: 40.0, // Customize the size as per your need
                          ),
                        );
                      } else if (state is AboutJobLoaded) {
                        return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            constraints: BoxConstraints(
                              maxHeight: _isCompletedJobsExpanded ? 230 : 0,
                            ),
                            child: ClipRect(
                                child: OverflowBox(
                              maxHeight: _isCompletedJobsExpanded ? 230 : 0,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: state.jobs.length,
                                itemBuilder: (context, index) {
                                  final job = state.jobs[index];

                                  // Improved function to handle date parsing and formatting
                                  String formatDate(String dateString) {
                                    try {
                                      DateTime parsedDate =
                                          DateTime.parse(dateString);
                                      return DateFormat('MMMM dd, yyyy')
                                          .format(parsedDate);
                                    } catch (e) {
                                      return 'Invalid date'; // Return a fallback if parsing fails
                                    }
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: CompletedJobCard(
                                        jobTitle: job.title,
                                        jobDescription: job.description,
                                        workPlace: job.location,
                                        date: formatDate(job.datePosted),
                                        wageRange: job.wageRange,
                                        // contact: job.poster.name,
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
                                                date:
                                                    formatDate(job.datePosted),
                                                workPlace: job.location,
                                                wageRange: job.wageRange,
                                                isCrypto: job.isCrypto,
                                                professions:
                                                    job.professions.join(', '),
                                                contact: job.poster.name,
                                                category:
                                                    job.categories.join(', '),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )));
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
                SectionTitleAboutJob(
                  title: 'Requested Jobs',
                  isExpanded: _isRequestedJobsExpanded,
                  onTap: () {
                    _toggleSection('requested');
                  },
                ),
                BlocProvider(
                  create: (context) => AboutJobBloc(
                      AboutJobRepository(authRepository: authRepository))
                    ..add(FetchAboutJobsByStatus('requested')),
                  child: BlocBuilder<AboutJobBloc, AboutJobState>(
                    builder: (context, state) {
                      if (state is AboutJobLoading) {
                        return const Center(
                          child: ProgressiveDots(
                            color: Colors.blue,
                            size: 40.0, // Customize the size as per your need
                          ),
                        );
                      } else if (state is AboutJobLoaded) {
                        return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            constraints: BoxConstraints(
                              maxHeight: _isRequestedJobsExpanded ? 230 : 0,
                            ),
                            child: ClipRect(
                                child: OverflowBox(
                              maxHeight: _isRequestedJobsExpanded ? 230 : 0,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: state.jobs.length,
                                itemBuilder: (context, index) {
                                  final job = state.jobs[index];

                                  // Improved function to handle date parsing and formatting
                                  String formatDate(String dateString) {
                                    try {
                                      DateTime parsedDate =
                                          DateTime.parse(dateString);
                                      return DateFormat('MMMM dd, yyyy')
                                          .format(parsedDate);
                                    } catch (e) {
                                      return 'Invalid date'; // Return a fallback if parsing fails
                                    }
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: RequestedJobCard(
                                        jobTitle: job.title,
                                        jobDescription: job.description,
                                        date: formatDate(job.datePosted),
                                        workPlace: job.location,
                                        wageRange: job.wageRange,
                                        //contact: job.poster.name,
                                        category: job.categories.join(', '),
                                        isCrypto: job.isCrypto,
                                        professions: job.professions.join(', '),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RequestedJobDetail(
                                                jobTitle: job.title,
                                                jobDescription: job.description,
                                                date:
                                                    formatDate(job.datePosted),
                                                workPlace: job.location,
                                                wageRange: job.wageRange,
                                                isCrypto: job.isCrypto,
                                                professions:
                                                    job.professions.join(', '),
                                                contact: job.poster.name,
                                                category:
                                                    job.categories.join(', '),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )));
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
                SectionTitleAboutJob(
                  title: 'Rejected Jobs',
                  isExpanded: _isRejectedJobsExpanded,
                  onTap: () {
                    _toggleSection('rejected');
                  },
                ),
                BlocProvider(
                  create: (context) => AboutJobBloc(
                      AboutJobRepository(authRepository: authRepository))
                    ..add(FetchAboutJobsByStatus('rejected')),
                  child: BlocBuilder<AboutJobBloc, AboutJobState>(
                    builder: (context, state) {
                      if (state is AboutJobLoading) {
                        return const Center(
                          child: ProgressiveDots(
                            color: Colors.blue,
                            size: 40.0, // Customize the size as per your need
                          ),
                        );
                      } else if (state is AboutJobLoaded) {
                        return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            constraints: BoxConstraints(
                              maxHeight: _isRejectedJobsExpanded ? 230 : 0,
                            ),
                            child: ClipRect(
                                child: OverflowBox(
                              maxHeight: _isRejectedJobsExpanded ? 230 : 0,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: state.jobs.length,
                                itemBuilder: (context, index) {
                                  final job = state.jobs[index];
                                  // Improved function to handle date parsing and formatting
                                  String formatDate(String dateString) {
                                    try {
                                      DateTime parsedDate =
                                          DateTime.parse(dateString);
                                      return DateFormat('MMMM dd, yyyy')
                                          .format(parsedDate);
                                    } catch (e) {
                                      return 'Invalid date'; // Return a fallback if parsing fails
                                    }
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: RejectedJobCard(
                                        jobTitle: job.title,
                                        jobDescription: job.description,
                                        date: formatDate(job.datePosted),
                                        workPlace: job.location,
                                        wageRange: job.wageRange,
                                        //contact: job.poster.name,
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
                                                date:
                                                    formatDate(job.datePosted),
                                                workPlace: job.location,
                                                wageRange: job.wageRange,
                                                isCrypto: job.isCrypto,
                                                professions:
                                                    job.professions.join(', '),
                                                contact: job.poster.name,
                                                category:
                                                    job.categories.join(', '),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )));
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
                SectionTitleAboutJob(
                  title: 'Posted Jobs',
                  isExpanded: _isPostedJobsExpanded,
                  onTap: () {
                    _toggleSection('posted');
                  },
                ),
                FutureBuilder<String?>(
                  future: AuthRepository(httpClient: http.Client())
                      .getUserId(), // Fetch userId asynchronously
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child:
                              CircularProgressIndicator()); // Show loader while waiting for userId
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                        child: Text(
                            'No User ID found. Please log in.'), // Handle null userId case
                      );
                    } else {
                      final String userId = snapshot
                          .data!; // Extract the userId from the snapshot

                      return BlocProvider(
                        create: (context) {
                          final authRepository =
                              AuthRepository(httpClient: http.Client());
                          final aboutJobRepository = AboutJobRepository(
                              authRepository: authRepository);

                          return AboutJobBloc(aboutJobRepository)
                            ..add(FetchJobsPostedByUser(userId));
                        },
                        child: BlocBuilder<AboutJobBloc, AboutJobState>(
                          builder: (context, state) {
                            if (state is AboutJobLoading) {
                              return const Center(
                                child: ProgressiveDots(
                                  color: Colors.blue,
                                  size:
                                      40.0, // Customize the size as per your need
                                ),
                              );
                            } else if (state is AboutJobLoaded) {
                              return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  constraints: BoxConstraints(
                                    maxHeight: _isPostedJobsExpanded ? 230 : 0,
                                  ),
                                  child: ClipRect(
                                      child: OverflowBox(
                                    maxHeight: _isPostedJobsExpanded ? 230 : 0,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: state.jobs.length,
                                      itemBuilder: (context, index) {
                                        final job = state.jobs[index];

                                        // Improved function to handle date parsing and formatting
                                        String formatDate(String dateString) {
                                          try {
                                            DateTime parsedDate =
                                                DateTime.parse(dateString);
                                            return DateFormat('MMMM dd, yyyy')
                                                .format(parsedDate);
                                          } catch (e) {
                                            return 'Invalid date'; // Fallback if parsing fails
                                          }
                                        }

                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 0),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            child: PostedJobCard(
                                              jobTitle: job.title,
                                              jobDescription: job.description,
                                              date: formatDate(job.datePosted),
                                              workPlace: job.location,
                                              wageRange: job.wageRange,
                                              //contact: job.poster.name,
                                              category:
                                                  job.categories.join(', '),
                                              isCrypto: job.isCrypto,
                                              professions:
                                                  job.professions.join(', '),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OwnJobDetailPage(
                                                      jobId: job.id,
                                                      jobTitle: job.title,
                                                      jobDescription:
                                                          job.description,
                                                      date: formatDate(
                                                          job.datePosted),
                                                      workPlace: job.location,
                                                      wageRange: job.wageRange,
                                                      isCrypto: job.isCrypto,
                                                      professions: job
                                                          .professions
                                                          .join(', '),
                                                      contact: job.poster.name,
                                                      category: job.categories
                                                          .join(', '),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )));
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
