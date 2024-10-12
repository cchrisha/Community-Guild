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
import 'post_page.dart';
import 'profile_page.dart';
import 'package:http/http.dart' as http; // Required for the repository
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        homeRepository: HomeRepository(httpClient: http.Client()),
      )..add(const LoadJobs('developer')), // Initialize Bloc and trigger event
      child: Scaffold(
        appBar: AppBar(
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
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: BlocBuilder<HomeBloc, HomeState>(
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
                            height: 240,
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
                                      overflow: TextOverflow.ellipsis,
                                      jobDescription: job.description ?? 'No description available',
                                      workPlace: job.location,
                                      date: DateFormat('MMMM dd, yyyy').format((job.datePosted)),
                                      wageRange: job.wageRange ?? 'No wage range specified',
                                      category: job.categories?.join(', ') ?? 'No categories available',
                                      isCrypto: job.isCrypto,
                                      professions: job.professions.join(', '),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => JobDetailPage(
                                              jobId: job.id,
                                              jobTitle: job.title,
                                              jobDescription: job.description ?? 'No description available',
                                              date: DateFormat('MMMM dd, yyyy').format((job.datePosted)),
                                              workPlace: job.location,
                                              wageRange: job.wageRange ?? 'No wage range specified',
                                              isCrypto: job.isCrypto,
                                              professions: job.professions.join(', '),
                                              contact: '',
                                              category: job.categories?.join(', ') ?? 'No categories available',
                                              posterName: job.posterName ?? 'Unknown poster',
                                                // Add this line
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
                            height: 240,
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
                                      overflow: TextOverflow.ellipsis,
                                      jobTitle: job.title,
                                      jobDescription: job.description ?? 'No description available',
                                      workPlace: job.location,
                                      date: DateFormat('MMMM dd, yyyy').format((job.datePosted)),
                                      wageRange: job.wageRange ?? 'No wage range specified',
                                      category: job.categories?.join(', ') ?? 'No categories available',
                                      isCrypto: job.isCrypto,
                                      professions: job.professions.join(', '),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => JobDetailPage(
                                              jobId: job.id,
                                              jobTitle: job.title,
                                              jobDescription: job.description ?? 'No description available',
                                              date: DateFormat('MMMM dd, yyyy').format((job.datePosted)),
                                              workPlace: job.location,
                                              wageRange: job.wageRange ?? 'No wage range specified',
                                              isCrypto: job.isCrypto,
                                              professions: job.professions.join(', '),
                                              contact: '',
                                              category: job.categories?.join(', ') ?? 'No categories available',
                                              posterName: job.posterName ?? 'Unknown poster',  // Add this line
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
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          currentIndex: 0,
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
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JobPage()),
                );
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
