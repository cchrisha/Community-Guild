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
  