import 'package:community_guild/bloc/userdetails/user_details_bloc.dart';
import 'package:community_guild/bloc/userdetails/user_details_event.dart';
import 'package:community_guild/bloc/userdetails/user_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:community_guild/widget/users_details/user_details_widget.dart'; // Import the UserInfoCard

class UserDetails extends StatelessWidget {
  final String posterName;

  const UserDetails({super.key, required this.posterName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserDetailsBloc()..add(LoadUserDetails(posterName)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Details'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<UserDetailsBloc, UserDetailsState>(
            builder: (context, state) {
              if (state is UserDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UserDetailsError) {
                return Center(child: Text(state.errorMessage));
              } else if (state is UserDetailsLoaded) {
                final userDetails = state.userDetails;
                return UserInfoCard(
                  name: userDetails['name'] ?? 'Unknown',
                  profession: userDetails['profession'] ?? 'N/A',
                  email: userDetails['email'] ?? 'N/A',
                  location: userDetails['location'] ?? 'N/A',
                  contact: userDetails['contact'] ?? 'N/A',
                  isVerified: userDetails['isVerify'] == 1,
                  // profilePictureUrl: userDetails['profilePictureUrl'] ?? '',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
