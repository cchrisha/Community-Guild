import 'package:equatable/equatable.dart';
import 'package:community_guild/models/job_model.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Job> jobs;

  HomeLoaded({required this.jobs});

  @override
  List<Object> get props => [jobs];
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);

  @override
  List<Object> get props => [message];
}
