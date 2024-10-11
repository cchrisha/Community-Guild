import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    on<SubmitJob>((event, emit) async {
      emit(PostLoading());

      final url = Uri.parse('https://api-tau-plum.vercel.app/api/jobs');
      const token = 'auth_token'; // Replace with your actual token

      try {
        // Prepare the job data
        final jobData = {
          "title": event.title,
          "wageRange": event.wageRange,
          "isCrypto": event.isCrypto,
          "location": event.location,
          "professions": event.profession,
          "categories": event.category,
          "description": event.description,
        };

        // Debugging: Print job data before making the request
        print('Job Data: $jobData');

        // Make the POST request to the API
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(jobData),
        );

        // Debugging: Print response status and body
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 201) {
          // Job posted successfully
          emit(PostSuccess());
        } else {
          // Something went wrong
          final responseBody = jsonDecode(response.body);
          emit(PostFailure(responseBody['message'] ?? 'An error occurred.'));
        }
      } catch (e) {
        print('Error occurred: ${e.toString()}'); // Log the error
        emit(PostFailure('Failed to post job. ${e.toString()}'));
      }
    });
  }
}
