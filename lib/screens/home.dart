import 'package:community_guild/widget/home/job_card.dart';
import 'package:community_guild/widget/home/search_and_filter.dart';
import 'package:community_guild/widget/home/home_section_title.dart';
import 'package:community_guild/widget/home/section_title.dart';
import 'package:flutter/material.dart';
import 'package:community_guild/screens/job_detail.dart';
import 'package:community_guild/screens/about_job.dart';
import 'package:community_guild/screens/notif_page.dart';
import 'package:community_guild/screens/payment_page.dart';
import 'package:community_guild/screens/post_page.dart';
import 'package:community_guild/screens/profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: CustomScrollView(
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
                    height: 240, // Increased height to accommodate new fields
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8, // Adjust card width relative to the screen width
                            child: HomeJobCard(
                              jobTitle: 'Recommended Job Title ${index + 1}',
                              jobDescription: 'This is the job description for recommended job ${index + 1}.',
                              location: 'Location ${index + 1}',
                              date: 'Date: 2024-09-${index + 1}', // Example date
                              wageRange: '\$${index * 1000 + 1000} - \$${index * 1000 + 2000}', // Example wage range
                              isCrypto: index % 2 == 0, // Alternate for crypto status
                              professions: 'Profession ${index + 1}',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const JobDetailPage(
                                      jobTitle: '',
                                      jobDescription: '',
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
                  const HomeSectionTitle(title: 'Most Recent Job'),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 240, // Increased height to accommodate new fields
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8, // Adjust card width relative to the screen width
                            child: HomeJobCard(
                              jobTitle: 'Recommended Job Title ${index + 1}',
                              jobDescription: 'This is the job description for recommended job ${index + 1}.',
                              location: 'Location ${index + 1}',
                              date: 'Date: 2024-09-${index + 1}', // Example date
                              wageRange: '\$${index * 1000 + 1000} - \$${index * 1000 + 2000}', // Example wage range
                              isCrypto: index % 2 == 0, // Alternate for crypto status
                              professions: 'Profession ${index + 1}',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const JobDetailPage(
                                      jobTitle: '',
                                      jobDescription: '',
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
    );
  }
}
