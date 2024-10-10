import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/job_posted_repository.dart';
import 'job_posted_event.dart';
import 'job_posted_state.dart';

class PostPageBloc extends Bloc<PostPageEvent, PostPageState> {
  final JobRepository jobRepository;

  PostPageBloc({required this.jobRepository}) : super(JobsInitialState()) {
    on<FetchJobsEvent>((event, emit) async {
      emit(JobsLoadingState());
      try {
        final jobs = await jobRepository.fetchJobs();
        emit(JobsLoadedState(jobs));
      } catch (error) {
        emit(JobsErrorState(error.toString()));
      }
    });
  }
}
