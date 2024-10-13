import 'package:community_guild/repository/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';
import '../widget/profile/profile_header.dart';
import '../widget/profile/verify_account_card.dart';
import '../widget/profile/profile_info_card.dart';
import 'edit_profile_page.dart';
import 'setting.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        profileRepository: ProfileRepository(),
      )..add(LoadProfile()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.lightBlue,
          elevation: 0,
          centerTitle: true,
          actions: [
            PopupMenuTheme(
              data: const PopupMenuThemeData(color: Colors.white),
              child: PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'Edit Info') {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
                    );

                    if (result == true) {
                      context.read<ProfileBloc>().add(LoadProfile());
                    }
                  } else if (value == 'Settings') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()),
                    );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'Edit Info',
                      child: Text(
                        'Edit Info',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Settings',
                      child: Text(
                        'Settings',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ];
                },
                icon: const Icon(Icons.menu, color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ProfileLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileHeader(
                      name: state.name,
                      profession: state.profession,
                    ),
                    const SizedBox(height: 15),
                    VerifyAccountCard(
                      onPressed: () {
                        BlocProvider.of<ProfileBloc>(context)
                            .add(VerifyAccount());
                      },
                    ),
                    const SizedBox(height: 30),
                    ProfileInfoCard(
                      location: state.location,
                      contact: state.contact,
                      email: state.email,
                      profession: state.profession,
                    ),
                    // const SizedBox(height: 30),
                    // _buildSection(context, 'Completed Jobs',
                    //     _buildCompletedJobList(context)),
                    // const SizedBox(height: 30),
                    // _buildSection(
                    //     context, 'Posted Jobs', _PostedJobList(context)),
                    // const SizedBox(height: 30),
                  ],
                );
              } else if (state is ProfileError) {
                return Center(child: Text(state.error));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  // Widget _buildCompletedJobList(BuildContext context) {
  //   return SizedBox(
  //     height: 240,
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: 3, // Change this to your actual data length
  //       itemBuilder: (context, index) {
  //         return Padding(
  //           padding: const EdgeInsets.only(right: 10),
  //           child: SizedBox(
  //             width: MediaQuery.of(context).size.width * 0.9,
  //             child: CompletedJobCard(
  //               jobTitle: 'Job Title $index', // Replace with actual data
  //               jobDescription:
  //                   'Description of job $index', // Replace with actual data
  //               workPlace: 'Workplace $index', // Replace with actual data
  //               date: 'Date $index', // Replace with actual data
  //               wageRange: 'Wage Range $index', // Replace with actual data
  //               contact: 'Contact $index', // Replace with actual data
  //               category: 'Category $index', // Replace with actual data
  //               isCrypto: index % 2 == 0, // Replace with actual data
  //               professions: 'Profession $index', // Replace with actual data
  //               onTap: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => const CompletedJobDetail(
  //                       jobTitle: '', // Replace with actual data
  //                       jobDescription: '', // Replace with actual data
  //                       date: '', // Replace with actual data
  //                       workPlace: '', // Replace with actual data
  //                       wageRange: '', // Replace with actual data
  //                       isCrypto: true, // Replace with actual data
  //                       professions: '', // Replace with actual data
  //                       contact: '', // Replace with actual data
  //                       category: '', // Replace with actual data
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  // Widget _buildSection(BuildContext context, String title, Widget content) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         title,
  //         style: const TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       content,
  //     ],
  //   );
  // }

  // Widget _PostedJobList(BuildContext context) {
  //   return SizedBox(
  //     height: 240,
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: 3, // Change this to your actual data length
  //       itemBuilder: (context, index) {
  //         return Padding(
  //           padding: const EdgeInsets.only(right: 10),
  //           child: SizedBox(
  //             width: MediaQuery.of(context).size.width * 0.9,
  //             child: CompletedJobCard(
  //               jobTitle: 'Job Title $index', // Replace with actual data
  //               jobDescription:
  //                   'Description of job $index', // Replace with actual data
  //               workPlace: 'Workplace $index', // Replace with actual data
  //               date: 'Date $index', // Replace with actual data
  //               wageRange: 'Wage Range $index', // Replace with actual data
  //               contact: 'Contact $index', // Replace with actual data
  //               category: 'Category $index', // Replace with actual data
  //               isCrypto: index % 2 == 0, // Replace with actual data
  //               professions: 'Profession $index', // Replace with actual data
  //               onTap: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => const OwnJobDetailPage(
  //                       jobTitle: '', // Replace with actual data
  //                       jobDescription: '', // Replace with actual data
  //                       date: '', // Replace with actual data
  //                       workPlace: '', // Replace with actual data
  //                       wageRange: '', // Replace with actual data
  //                       isCrypto: true, // Replace with actual data
  //                       professions: '', // Replace with actual data
  //                       contact: '', // Replace with actual data
  //                       category: '', // Replace with actual data
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}
