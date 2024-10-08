import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:community_guild/repository/job_repository.dart'; // Import JobRepository
import 'post_event.dart';
import 'post_state.dart';
import 'package:community_guild/models/job_model.dart'; // Import Job model

class PostBloc extends Bloc<PostEvent, PostState> {
  final JobRepository jobRepository;

  PostBloc(this.jobRepository) : super(PostInitial()) {
    on<SubmitJob>((event, emit) async {
      emit(PostLoading());
      try {
        // Simulate a network call for job posting
        final job = Job(
          id: '', // Generate a unique ID for the job
          title: event.title,
          wageRange: event.wageRange,
          isCrypto: event.isCrypto,
          location: event.location,
          datePosted: DateTime.now(),
          description: event.description,
          professions: event.professions,
          categories: event.categories,
          poster: event.poster,
        );

        await jobRepository.createJob(job);

        emit(PostSuccess());
      } catch (e) {
        emit(PostFailure('Failed to post job.', message: e.toString()));
      }
    });
  }
}

