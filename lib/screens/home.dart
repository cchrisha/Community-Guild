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
  try {
    // Assuming you have the user's ID or a token to identify them
    final response = await http.get(Uri.parse('https://api-tau-plum.vercel.app/api/isUserVerify'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['isVerified'] == 1; // Assuming the response has isVerified field
    } else {
      throw Exception('Failed to check user verification');
    }
  } catch (e) {
    print('Error: $e');
    return false; // Assume not verified on error
  }
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
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: _currentIndex == 2 // When on PostInput page
            ? null // Hide bottom navigation bar
            : BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                selectedItemColor: Colors.lightBlue,
                unselectedItemColor: Colors.black,
               onTap: (index) async {
                    setState(() {
                      _currentIndex = index;

                      if (_currentIndex == 2) { // When Post is selected
                        _isUserVerified().then((_) {
                          if (isUserVerified) {
                            // Show SnackBar if user is verified
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Your account is verified'),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Redirect to the Post Input page
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PostInput()),
                            ).then((_) {
                              setState(() {
                                _currentIndex = 0; // Reset to Home
                              });
                            });
                          } else {
                            // Show dialog if user is not verified
                            showDialog(
                              context: context,
                              barrierDismissible: false, // Prevent closing by tapping outside
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Account Verification Required'),
                                  content: const Text('Please verify your account before posting.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close the dialog
                                        setState(() {
                                          _currentIndex = 4; // Redirect to Profile tab
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        });
                      }
                    });
                  }
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

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SearchAndFilter(),
                      const SizedBox(height: 20),
                      const SectionTitle(title: 'Recommended'),
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.recommendedJobs.length,
                          itemBuilder: (context, index) {
                            final job = state.recommendedJobs[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: HomeJobCard(
                                  jobTitle: job.title,
                                  jobDescription: job.description ??
                                      'No description available',
                                  workPlace: job.location,
                                  date: DateFormat('MMMM dd, yyyy')
                                      .format(job.datePosted),
                                  wageRange: job.wageRange ??
                                      'No wage range specified',
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
                                          professions:
                                              job.professions.join(', '),
                                          contact: '',
                                          category:
                                              job.categories?.join(', ') ??
                                                  'No categories available',
                                          posterName: job.posterName ??
                                              'Unknown poster',
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
                      const SectionTitle(title: 'Most Recent Job'),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.recentJobs.length,
                          itemBuilder: (context, index) {
                            final job = state.recentJobs[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: HomeJobCard(
                                  jobTitle: job.title,
                                  jobDescription: job.description ??
                                      'No description available',
                                  workPlace: job.location,
                                  date: DateFormat('MMMM dd, yyyy')
                                      .format(job.datePosted),
                                  wageRange: job.wageRange ??
                                      'No wage range specified',
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
                                          professions:
                                              job.professions.join(', '),
                                          contact: '',
                                          category:
                                              job.categories?.join(', ') ??
                                                  'No categories available',
                                          posterName: job.posterName ??
                                              'Unknown poster',
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
            ],
          );
        } else if (state is HomeError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('Welcome to the home page!'));
      },
    );
  }
}
