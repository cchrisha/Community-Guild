import 'package:equatable/equatable.dart';

abstract class AboutJobEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAboutJobsByStatus extends AboutJobEvent {
  final String status;
  FetchAboutJobsByStatus(this.status);
}

class FetchJobsPostedByUser extends AboutJobEvent {
  final String userId;
  FetchJobsPostedByUser(this.userId);
}

abstract class JobRequestsEvent {}

class FetchJobRequests extends JobRequestsEvent {
  final String jobId;
  FetchJobRequests(this.jobId);
}

class FetchJobApplicants extends AboutJobEvent {
  final String jobId;

  FetchJobApplicants(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

class FetchJobWorkers extends AboutJobEvent {
  final String jobId;

  FetchJobWorkers(this.jobId);

  @override
  List<Object?> get props => [jobId];
}



