import 'package:flutter/material.dart';
import 'package:community_guild/screens/about_job.dart';
import 'package:community_guild/screens/home.dart';
import 'package:community_guild/screens/notif_page.dart';
import 'package:community_guild/screens/post_page.dart';
import 'package:community_guild/screens/profile_page.dart';
import '../widget/payment/balance_card.dart';
import '../widget/payment/section_title.dart';
import '../widget/payment/job_card.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                expandedHeight: 200.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: const SizedBox.shrink(),
                  background: Container(
                    color: const Color.fromARGB(255, 3, 169, 244),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              BalanceCard(),
                              SizedBox(width: 5),
                              //YourEarnsCard(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  const Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left:
                                30.0), // Add space between Payment text and the right edge
                        child: Text(
                          'Payment',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PaymentSectionTitle(title: 'Actions'),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildColoredIconButton(context, Icons.send, 'Send'),
                          _buildColoredIconButton(
                              context, Icons.download, 'Withdraw'),
                          _buildColoredIconButton(
                              context, Icons.attach_money, 'Deposit'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const PaymentSectionTitle(title: 'To Pay'),
                      const SizedBox(height: 10),
                      const PaymentJobCardPage(
                          description: 'Job post details that need payment.'),
                      const SizedBox(height: 20),
                      const PaymentSectionTitle(title: 'To Receive Payment'),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: PaymentJobCardPage(
                          description: 'Job post details awaiting payment.'),
                    );
                  },
                  childCount: 10,
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        currentIndex: 3,
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
        unselectedItemColor: Colors.lightBlue,
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PostPage()),
              );
              break;
            case 3:
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

Widget _buildColoredIconButton(
    BuildContext context, IconData icon, String label) {
  return Column(
    children: [
      Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 3, 169, 244),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(icon, size: 20, color: Colors.white),
          onPressed: () {
            // Add navigation or action for this button
          },
        ),
      ),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(fontSize: 14)),
    ],
  );
}
