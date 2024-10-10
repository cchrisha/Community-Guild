import 'package:equatable/equatable.dart';

abstract class JobState extends Equatable {
  const JobState();

  @override
  List<Object> get props => [];
}

class JobInitial extends JobState {}

class JobLoading extends JobState {}

class JobLoaded extends JobState {
  final Map<String, dynamic> job;

  const JobLoaded(this.job);

  @override
  List<Object> get props => [job];
}

class JobError extends JobState {
  final String error;

  const JobError(this.error);

  @override
  List<Object> get props => [error];
}
