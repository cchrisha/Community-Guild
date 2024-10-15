import 'package:community_guild/models/about_job_model.dart';
import 'package:equatable/equatable.dart';
//import 'about_job_model.dart'; // Assuming you have a model for Job

abstract class AboutJobState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AboutJobInitial extends AboutJobState {
  @override
  List<Object?> get props => [];
}

class AboutJobLoading extends AboutJobState {
  @override
  List<Object?> get props => [];
}

class AboutJobLoaded extends AboutJobState {
  final List<AboutJobModel> jobs;

  AboutJobLoaded(this.jobs);

  @override
  List<Object?> get props => [jobs];
}

class AboutJobError extends AboutJobState {
  final String message;

  AboutJobError(this.message);

  @override
  List<Object?> get props => [message];
}

class AboutJobApplicantsLoading extends AboutJobState {}

class AboutJobApplicantsLoaded extends AboutJobState {
  final List<Map<String, String>> applicants;


  AboutJobApplicantsLoaded(this.applicants);

  @override
  List<Object?> get props => [applicants];
}

class AboutJobApplicantsError extends AboutJobState {
  final String message;

  AboutJobApplicantsError(this.message);

  @override
  List<Object?> get props => [message];
}

class AboutJobWorkersLoading extends AboutJobState {}

class AboutJobWorkersLoaded extends AboutJobState {
  final List<Map<String, String>> workers;

    AboutJobWorkersLoaded(this.workers);

  @override
  List<Object?> get props => [workers];
}

class AboutJobWorkersError extends AboutJobState {
  final String message;

  AboutJobWorkersError(this.message);

  @override
  List<Object?> get props => [message];
}

class AboutJobRequestUpdated extends AboutJobState {
  final String message;

  AboutJobRequestUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

class AboutJobWorkerUpdated extends AboutJobState {
  final String message;

  AboutJobWorkerUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

// class AcceptApplicantSuccess extends AboutJobState {
//   final String message;

//   AcceptApplicantSuccess(this.message);

//   @override
//   List<Object> get props => [message];
// }

// class AcceptApplicantError extends AboutJobState {
//   final String message;

//   AcceptApplicantError(this.message);

//   @override
//   List<Object> get props => [message];
// }

// class WorkerMarkedDoneSuccess extends AboutJobState {
//   final String message;

//   WorkerMarkedDoneSuccess(this.message);

//   @override
//   List<Object> get props => [message];
// }

// class WorkerMarkedDoneError extends AboutJobState {
//   final String message;

//   WorkerMarkedDoneError(this.message);

//   @override
//   List<Object> get props => [message];
// }

// about_job_state.dart

class AcceptApplicantSuccess extends AboutJobState {}

class MarkWorkerDoneSuccess extends AboutJobState {}

class AboutJobActionError extends AboutJobState {
  final String message;

  AboutJobActionError(this.message);

  @override
  List<Object> get props => [message];
}

