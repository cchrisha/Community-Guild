import 'package:equatable/equatable.dart';
import 'package:community_guild/models/job_home_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Job> recommendedJobs;
  final List<Job> recentJobs;

  const HomeLoaded({
    required this.recommendedJobs,
    required this.recentJobs,
  });

  @override
  List<Object> get props => [recommendedJobs, recentJobs];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object> get props => [message];
}
