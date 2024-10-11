import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    on<SubmitJob>((event, emit) async {
      emit(PostLoading());
      try {
        final prefs = await SharedPreferences.getInstance();
        final authToken = prefs.getString('auth_token');

        if (authToken == null) {
          emit(PostFailure('No token found'));
          return;
        }

        final response = await http.post(
          Uri.parse('https://api-tau-plum.vercel.app/api/jobs'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
          body: jsonEncode({
            'title': event.title,
            'location': event.location,
            'profession': event.profession,
            'category': event.categories,
            'wageRange': event.wageRange,
            'contact': event.contact,
            'description': event.description,
            'isCrypto': event.isCrypto,
          }),
        );

        if (response.statusCode == 201) {
          emit(PostSuccess());
        } else {
          final errorMessage =
              jsonDecode(response.body)['message'] ?? 'Failed to post job.';
          emit(PostFailure(errorMessage));
        }
      } catch (e) {
        emit(PostFailure('Network Error: ${e.toString()}'));
      }
    });
  }
}
