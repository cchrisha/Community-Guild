import 'package:community_guild/screens/notif_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:community_guild/bloc/home/home_bloc.dart';
import 'package:community_guild/bloc/home/home_event.dart';
import 'package:community_guild/bloc/home/home_state.dart';

import '../widget/home/job_card.dart';
import '../widget/home/search_and_filter.dart';
import '../widget/home/section_title.dart';
import 'job_detail.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(FetchJobs()), // Fetch jobs on load
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: const Color.fromARGB(255, 3, 169, 244),
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
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
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
                            height: 210,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.jobs.length,
                              itemBuilder: (context, index) {
                                final job = state.jobs[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: HomeJobCard(
                                      jobTitle: job['title'],
                                      jobDescription: job['description'],
                                      workPlace: 'Workplace ${index + 1}',
                                      date: 'Date: 2024-09-${index + 1}',
                                      wageRange:
                                          '\$${index * 1000 + 1000} - \$${index * 1000 + 2000}',
                                      isCrypto: index % 2 == 0,
                                      professions: 'Profession ${index + 1}',
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const JobDetailPage(
                                              jobTitle: '',
                                              jobDescription: '',
                                              date: '',
                                              workPlace: '',
                                              wageRange: '',
                                              isCrypto: true,
                                              professions: '',
                                              contact: '',
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
      ),
    );
  }
}
