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
  final List<String> applicants;

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
  final List<String> workers;

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
