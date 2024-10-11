import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/about_job_repository.dart';
import 'about_job_event.dart';
import 'about_job_state.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  final JobRepository jobRepository;

  JobBloc(this.jobRepository) : super(JobInitial()) {
    on<FetchJobs>(_onFetchJobs);
  }

    }
  }
}
