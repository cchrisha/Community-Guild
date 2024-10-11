import 'package:community_guild/bloc/jobposted/job_posted_event.dart';
import 'package:community_guild/bloc/postpage/postpage_state.dart';
import 'package:community_guild/models/job_model.dart';
import 'package:community_guild/repository/job_posted_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostPageBloc extends Bloc<PostPageEvent, PostPageState> {
  final JobRepository jobRepository;

  PostPageBloc({required this.jobRepository})
      : super(PostPageInitial()); // Set the initial state

  @override
  Stream<PostPageState> mapEventToState(PostPageEvent event) async* {
    if (event is FetchJobsEvent) {
      yield JobsLoadingState(); // Emit loading state
      try {
        final jobs =
            await jobRepository.fetchJobs(); // Fetch jobs from the repository
        yield JobsLoadedState(jobs.cast<Job>()); // Emit loaded state with jobs
      } catch (error) {
        yield JobsErrorState(
            'Failed to fetch jobs: $error'); // Emit error state
      }
    }
  }
}
