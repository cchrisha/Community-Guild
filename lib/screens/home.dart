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
import '../widget/home/bottom_nav.dart';
import '../widget/loading_widget/ink_drop.dart';
import 'about_job.dart';
import 'job_detail.dart';
import 'payment_page.dart';
import 'profile_page.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  HomeBloc? _homeBloc;

  final List<Widget> _pages = [
    const HomePageBody(),
    const JobPage(),
    const PostInput(),
    const PaymentPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc(
      homeRepository: HomeRepository(httpClient: http.Client()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _homeBloc!..add(const LoadJobs('developer')),
      child: Scaffold(
        backgroundColor: Colors.white,
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
                backgroundColor: Colors.lightBlue,
                automaticallyImplyLeading: false,
              )
            : null,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _pages[_currentIndex],
        ),
        bottomNavigationBar: _currentIndex == 2
            ? null
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _currentIndex,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  selectedItemColor: Colors.black,
                  unselectedItemColor: Colors.grey,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: [
                    _buildCustomNavItem(Icons.home_outlined, 'Home', 0),
                    _buildCustomNavItem(Icons.task_outlined, 'Task', 1),
                    _buildCustomNavItem(Icons.post_add_outlined, 'Post', 2),
                    _buildCustomNavItem(Icons.payment_outlined, 'Payment', 3),
                    _buildCustomNavItem(Icons.person_2_outlined, 'Profile', 4),
                  ],
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });

                    if (_currentIndex == 0) {
                      // Trigger job loading when "Home" is tapped
                      _homeBloc!.add(const LoadJobs('developer'));
                    }

                    if (_currentIndex == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PostInput(),
                        ),
                      ).then((_) {
                        setState(() {
                          _currentIndex = 0;
                        });
                        // Trigger job loading when returning to "Home"
                        _homeBloc!.add(const LoadJobs('developer'));
                      });
                    }
                  },
                ),
              ),
      ),
    );
  }

  BottomNavigationBarItem _buildCustomNavItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: CustomBottomNavItem(
        icon: icon,
        label: label,
        isSelected: _currentIndex == index,
      ),
      label: '',
    );
  }

  @override
  void dispose() {
    _homeBloc?.close();
    super.dispose();
  }
}

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return Center(
            child: InkDrop(
              size: 40.0,
              color: Colors.lightBlue,
              ringColor: Colors.lightBlue.withOpacity(0.1),
            ),
          );
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
                    color: const Color.fromARGB(255, 252, 252, 252),
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
                                        // contact: '',
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
                                        // contact: '',
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
          return const Center(
            child: Text('Error loading jobs.'),
          );
        }
      },
    );
  }
}
