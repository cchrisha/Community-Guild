import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_detail/user_detail_bloc.dart';
import '../bloc/user_detail/user_detail_event.dart';
import '../bloc/user_detail/user_detail_state.dart';
import 'package:community_guild/widget/loading_widget/ink_drop.dart';

class UserDetails extends StatelessWidget {
  final String posterName;

  const UserDetails({super.key, required this.posterName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc()..add(FetchUserDetails(posterName)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'User Details',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.lightBlue,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(
                child: InkDrop(
                    size: 40,
                    color: Colors
                        .lightBlue), // Show InkDrop instead of CircularProgressIndicator
              );
            } else if (state is UserError) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is UserLoaded) {
              final userDetails = state.userDetails;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color.fromARGB(255, 3, 169, 244),
                              width: 4,
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(
                                userDetails['profilePicture'] ??
                                    'https://via.placeholder.com/150',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          userDetails['name'],
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Contact Info',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.email,
                                  color: Color.fromARGB(255, 3, 169, 244),
                                ),
                                title: Text(userDetails['email']),
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(
                                  Icons.location_on,
                                  color: Color.fromARGB(255, 3, 169, 244),
                                ),
                                title: Text(userDetails['location']),
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(
                                  Icons.phone,
                                  color: Color.fromARGB(255, 3, 169, 244),
                                ),
                                title: Text(userDetails['contact']),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Professional Info',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.work,
                                  color: Color.fromARGB(255, 3, 169, 244),
                                ),
                                title: Text(userDetails['profession']),
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(
                                  Icons.verified,
                                  color: Color.fromARGB(255, 3, 169, 244),
                                ),
                                title: Text(
                                    'Verified: ${userDetails['isVerify'] == 1 ? 'Yes' : 'No'}'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
