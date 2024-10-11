import 'package:community_guild/models/job_model.dart';

abstract class PostPageState {}

class PostPageInitial extends PostPageState {} // Define the initial state

class JobsLoadingState extends PostPageState {}

class JobsLoadedState extends PostPageState {
  final List<Job> jobs; // Assuming Job is a model class

  JobsLoadedState(this.jobs);
}

class JobsErrorState extends PostPageState {
  final String message;

  JobsErrorState(this.message);
}
