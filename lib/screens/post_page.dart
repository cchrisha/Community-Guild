import 'package:community_guild/screens/about_job.dart';
import 'package:community_guild/screens/payment_page.dart';
import 'package:community_guild/screens/profile_page.dart';
import 'package:community_guild/widget/post_page/section_title.dart';
import 'package:flutter/material.dart';
import 'home.dart'; // assuming home.dart is in the same directory
import 'post_input.dart';
import 'package:community_guild/widget/post_page/post_job_card3.dart';
import 'package:community_guild/screens/own_post_job_detail.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(
              left: 16.0), // Adjust this value to move the text right
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
      body: SingleChildScrollView(
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
                          builder: (context) => const PostInput()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 3, 169,
                        244), // Color for the main button (matching the app bar color)
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Rounded corners
                    ),
                    elevation: 5, // Adds shadow like in the image
                  ),
                  child: Container(
                    height: 60,
                    width: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(216, 246, 246,
                          246), // Lighter color for the inner box
                      borderRadius:
                          BorderRadius.circular(10), // Rounded inner box
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.black, // Plus icon color
                      size: 30,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // Recommended Section (example of the similar SizedBox from Recommended Section)
              const SectionTitlePostPage(title: 'Posted Jobs'),
              const SizedBox(height: 10),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.8, //responsive na width
                        child: PostedJobCard3(
                          jobTitle: 'Job Title $index', // Replace with actual data
                          jobDescription: 'Description of job $index', // Replace with actual data
                          workPlace: 'Workplace $index', // Replace with actual data
                          date: 'Date $index', // Replace with actual data
                          wageRange: 'Wage Range $index', // Replace with actual data
                          contact: 'Contact $index', // Replace with actual data
                          category: 'Category $index', // Replace with actual data
                          isCrypto: index % 2 == 0, // Replace with actual data
                          professions: 'Profession $index', // Replace with actual data
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OwnJobDetailPage(
                                  jobTitle: '', // Replace with actual data
                                  jobDescription: '', // Replace with actual data
                                  date: '', // Replace with actual data
                                  workPlace: '', // Replace with actual data
                                  wageRange: '', // Replace with actual data
                                  isCrypto: true, // Replace with actual data
                                  professions: '', // Replace with actual data
                                  contact: '', // Replace with actual data
                                  category: '', // Replace with actual data
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const JobPage()),
              );
              break;
            case 2:
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
    );
  }
}
