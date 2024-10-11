import 'package:equatable/equatable.dart';

abstract class JobState extends Equatable {
  const JobState();

  @override
  List<Object> get props => [];
}

class JobInitial extends JobState {}

class JobLoading extends JobState {}

class JobLoaded extends JobState {
  final List<dynamic> jobs;

  const JobLoaded(this.jobs);

  @override
  List<Object> get props => [jobs];
}

class JobError extends JobState {
  final String message;

  const JobError(this.message);

  @override
  List<Object> get props => [message];
}
