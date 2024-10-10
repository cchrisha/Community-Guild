import '../../models/job_posted_model.dart';

abstract class PostPageState {}

class JobsInitialState extends PostPageState {}

class JobsLoadingState extends PostPageState {}

class JobsLoadedState extends PostPageState {
  final List<Job> jobs;
  JobsLoadedState(this.jobs);
}

class JobsErrorState extends PostPageState {
  final String message;
  JobsErrorState(this.message);
}
