import 'package:community_guild/repository/all_job_detail/job_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'post_event.dart';
import 'post_state.dart';
import 'package:shared_preferences/shared_preferences.dart'; // To get token

class PostBloc extends Bloc<PostEvent, PostState> {
  final JobRepository jobRepository;

  PostBloc({required this.jobRepository}) : super(PostInitial()) {
    on<SubmitJob>((event, emit) async {
      emit(PostLoading());

      try {
        // Retrieve token from SharedPreferences (assuming you store it there)
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('auth_token');
        if (token == null) {
          throw Exception('User is not authenticated');
        }

        // Make the network call to post the job
        await jobRepository.postJob(
          title: event.title,
          wageRange: event.wageRange,
          isCrypto: event.isCrypto,
          location: event.location,
          professions: event.profession,
          categories: event.category,
          description: event.description,
          token: token,
        );

        emit(PostSuccess());
      } catch (e) {
        emit(PostFailure('Failed to post job.', message: e.toString()));
      }
    });
  }
}
