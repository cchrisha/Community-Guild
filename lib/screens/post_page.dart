import 'package:community_guild/bloc/post/post_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/jobposted/job_posted_bloc.dart';
import '../bloc/jobposted/job_posted_event.dart';
import '../bloc/jobposted/job_posted_state.dart';
import '../repository/job_posted_repository.dart';
import '../widget/post_page/post_job_card3.dart';
import '../widget/post_page/section_title.dart';
import 'about_job.dart';
import 'home.dart';
import 'own_post_job_detail.dart';
import 'payment_page.dart';
import 'post_input.dart';
import 'profile_page.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Text(
            'Create a Job Post',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 3, 169, 244),
      ),
      body: BlocProvider(
        create: (context) =>
            PostPageBloc(jobRepository: JobRepository())..add(FetchJobsEvent()),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) =>
                                PostBloc(), // Provide PostBloc here
                            child: const PostInput(),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 3, 169, 244),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 5,
                    ),
                    child: Container(
                      height: 60,
                      width: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(216, 246, 246, 246),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const SectionTitlePostPage(title: 'Posted Jobs'),
                const SizedBox(height: 10),
                BlocBuilder<PostPageBloc, PostPageState>(
                  builder: (context, state) {
                    if (state is JobsLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is JobsLoadedState) {
                      return SizedBox(
                        height: 230,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.jobs.length,
                          itemBuilder: (context, index) {
                            final job = state.jobs[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: PostedJobCard3(
                                  jobTitle: job.jobTitle,
                                  jobDescription: job.jobDescription,
                                  workPlace: job.workPlace,
                                  date: job.date,
                                  wageRange: job.wageRange,
                                  contact: job.contact,
                                  category: job.category,
                                  isCrypto: job.isCrypto,
                                  professions: job.professions,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OwnJobDetailPage(
                                          jobTitle: job.jobTitle,
                                          jobDescription: job.jobDescription,
                                          date: job.date,
                                          workPlace: job.workPlace,
                                          wageRange: job.wageRange,
                                          isCrypto: job.isCrypto,
                                          professions: job.professions,
                                          contact: job.contact,
                                          category: job.category,
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
                    } else if (state is JobsErrorState) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.info_outline), label: 'About Job'),
          BottomNavigationBarItem(icon: Icon(Icons.post_add), label: 'Post'),
          BottomNavigationBarItem(
              icon: Icon(Icons.payment_outlined), label: 'Payment'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined), label: 'Profile'),
        ],
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.black,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
              break;
            case 1:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const JobPage()));
              break;
            case 2:
              break;
            case 3:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const PaymentPage()));
              break;
            case 4:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
              break;
          }
        },
      ),
    );
  }
}
