abstract class AboutJobState {}

class JobInitial extends AboutJobState {}

class JobLoading extends AboutJobState {}

class JobLoaded extends AboutJobState {
  final List<String>
      jobTitles; // This can be replaced with your actual job model

  JobLoaded(this.jobTitles);
}

class JobError extends AboutJobState {
  final String message;

  JobError(this.message);
}
