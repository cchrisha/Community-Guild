import 'package:community_guild/repository/job_repository.dart';
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
import 'notif_page.dart';
import 'payment_page.dart';
import 'post_page.dart';
import 'profile_page.dart';
import 'package:http/http.dart' as http;
import 'package:community_guild/repository/home_repository.dart';  // Import the HomeRepository

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        HomeRepository(httpClient: http.Client()), // Inject HomeRepository here
      )..add(LoadJobs()), // Fetch jobs when the page loads
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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
              // Display the jobs
              return ListView.builder(
                itemCount: state.jobs.length,
                itemBuilder: (context, index) {
                  final job = state.jobs[index];
                  return HomeJobCard(
                    jobTitle: job.title,
                    jobDescription: job.description,
                    workPlace: job.location,
                    date: job.datePosted.toString(),
                    wageRange: job.wageRange,
                    category: job.categories.join(', '),
                    isCrypto: job.isCrypto,
                    professions: job.professions.join(', '),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobDetailPage(
                            jobTitle: job.title,
                            jobDescription: job.description,
                            date: job.datePosted.toString(),
                            wageRange: job.wageRange,
                            isCrypto: job.isCrypto,
                            professions: job.professions.join(', '),
                            workPlace: job.location,
                            // Ensure this is correct
                            contact: job.poster?.name ?? 'N/A',
                            category: job.categories.join(', '),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is HomeError) {
              // Display the error message
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
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
      ),
    );
  }
}
