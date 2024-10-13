import 'dart:convert';
import 'package:community_guild/repository/home_repository.dart';
import 'package:community_guild/screens/post_input.dart';
import 'package:community_guild/widget/home/job_card.dart';
import 'package:community_guild/widget/home/search_and_filter.dart';
import 'package:community_guild/widget/home/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:community_guild/bloc/home/home_bloc.dart';
import 'package:community_guild/bloc/home/home_event.dart';
import 'package:community_guild/bloc/home/home_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about_job.dart';
import 'job_detail.dart';
import 'payment_page.dart';
import 'profile_page.dart';
import 'package:http/http.dart' as http; // Required for the repository
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool isUserVerified = false;
  final List<Widget> _pages = [
    const HomePageBody(), // The existing body of your HomePage
    const JobPage(), // Add About Job Page here
    const PostInput(), // Post Input Page
    const PaymentPage(), // Payment Page
    const ProfilePage(), // Profile Page
  ];

  Future<bool> _isUserVerified() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? isVerify = prefs.getInt('isVerify');
    return isVerify == 1; // Return true if verified, otherwise false
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        homeRepository: HomeRepository(httpClient: http.Client()),
      )..add(const LoadJobs('developer')),
      child: Scaffold(
        appBar: _currentIndex == 0
            ? AppBar(
                title: const Row(
                  children: [
                    SizedBox(width: 16),
                    Text(
                      'Home',
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
              )
            : null,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: AnimatedSwitcher(
          duration:
              const Duration(milliseconds: 300), // Duration of the animation
          child: _pages[_currentIndex], // Set the current page
        ),
        bottomNavigationBar: _currentIndex == 2 // When on PostInput page
            ? null // Hide bottom navigation bar
            : BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: const Color.fromARGB(255, 3, 169, 244),
                currentIndex: _currentIndex,
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
                unselectedItemColor: Colors.white,
                onTap: (index) async {
                  setState(() {
                    _currentIndex = index;
                  });

                  if (_currentIndex == 2) {
                    // When Post is selected
                    isUserVerified =
                        await _isUserVerified(); // Await the verification check

                    if (isUserVerified) {
                      // Show SnackBar if user is verified
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Your account is verified. You can now post.'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // Redirect to the Post Input page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PostInput()),
                      ).then((_) {
                        setState(() {
                          _currentIndex = 0; // Reset to Home after posting
                        });
                      });
                    } else {
                      // Show dialog if user is not verified
                      showDialog(
                        context: context,
                        barrierDismissible:
                            false, // Prevent closing by tapping outside
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Account Verification Required'),
                            content: const Text(
                                'Please verify your account before posting.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Close'),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  setState(() {
                                    _currentIndex =
                                        4; // Redirect to Profile tab
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
              ),
      ),
    );
  }
}

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeLoaded) {
          if (state.recommendedJobs.isEmpty) {
            return const Center(
              child: Text(
                'No jobs available at the moment.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 0.0),
                child: SearchAndFilter(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    color: const Color.fromARGB(255, 224, 247, 255),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        const SectionTitle(title: 'Recommendations'),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.recommendedJobs.length,
                          itemBuilder: (context, index) {
                            final job = state.recommendedJobs[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: HomeJobCard(
                                jobTitle: job.title,
                                jobDescription: job.description ??
                                    'No description available',
                                workPlace: job.location,
                                date: DateFormat('MMMM dd, yyyy')
                                    .format(job.datePosted),
                                wageRange:
                                    job.wageRange ?? 'No wage range specified',
                                category: job.categories?.join(', ') ??
                                    'No categories available',
                                isCrypto: job.isCrypto,
                                professions: job.professions.join(', '),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JobDetailPage(
                                        jobId: job.id,
                                        jobTitle: job.title,
                                        jobDescription: job.description ??
                                            'No description available',
                                        date: DateFormat('MMMM dd, yyyy')
                                            .format(job.datePosted),
                                        workPlace: job.location,
                                        wageRange: job.wageRange ??
                                            'No wage range specified',
                                        isCrypto: job.isCrypto,
                                        professions: job.professions.join(', '),
                                        contact: '',
                                        category: job.categories?.join(', ') ??
                                            'No categories available',
                                        posterName:
                                            job.posterName ?? 'Unknown poster',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        const SectionTitle(title: 'Most Recent Jobs'),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.recentJobs.length,
                          itemBuilder: (context, index) {
                            final job = state.recentJobs[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: HomeJobCard(
                                jobTitle: job.title,
                                jobDescription: job.description ??
                                    'No description available',
                                workPlace: job.location,
                                date: DateFormat('MMMM dd, yyyy')
                                    .format(job.datePosted),
                                wageRange:
                                    job.wageRange ?? 'No wage range specified',
                                category: job.categories?.join(', ') ??
                                    'No categories available',
                                isCrypto: job.isCrypto,
                                professions: job.professions.join(', '),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JobDetailPage(
                                        jobId: job.id,
                                        jobTitle: job.title,
                                        jobDescription: job.description ??
                                            'No description available',
                                        date: DateFormat('MMMM dd, yyyy')
                                            .format(job.datePosted),
                                        workPlace: job.location,
                                        wageRange: job.wageRange ??
                                            'No wage range specified',
                                        isCrypto: job.isCrypto,
                                        professions: job.professions.join(', '),
                                        contact: '',
                                        category: job.categories?.join(', ') ??
                                            'No categories available',
                                        posterName:
                                            job.posterName ?? 'Unknown poster',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: Text('Error loading jobs.'));
        }
      },
    );
  }
}
