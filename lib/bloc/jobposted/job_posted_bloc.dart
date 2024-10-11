import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/all_job_detail/job_posted_repository.dart';
import 'job_posted_event.dart';
import 'job_posted_state.dart';

class PostPageBloc extends Bloc<PostPageEvent, PostPageState> {
  final JobPostedRepository jobRepository;

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
