import 'package:flutter_bloc/flutter_bloc.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    on<SubmitJob>((event, emit) async {
      emit(PostLoading());
      try {
        // Simulate a network call for job posting
        await Future.delayed(const Duration(seconds: 2));

        // Here you would normally send the job data to your backend
        // For example: await jobRepository.postJob(event);

        emit(PostSuccess());
      } catch (e) {
        emit(PostFailure('Failed to post job.', message: ''));
      }
    });
  }
}
