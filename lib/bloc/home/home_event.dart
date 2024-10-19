import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadJobs extends HomeEvent {
  final String profession;

  const LoadJobs(this.profession);

  @override
  List<Object> get props => [profession];
}

class SearchJobs extends HomeEvent {
  final String query;

  const SearchJobs(this.query);
}
