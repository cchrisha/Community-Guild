import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitJob extends PostEvent {
  final String title;
  final String location;
  final String wageRange;
  final bool isCrypto;
  final String description;
  final List<String> professions;
  final List<String> categories;
  final String poster;

  SubmitJob({
    required this.title,
    required this.location,
    required this.wageRange,
    required this.isCrypto,
    required this.description,
    required this.professions,
    required this.categories,
    required this.poster,
  });

  @override
  List<Object?> get props =>
      [title, location, wageRange, isCrypto, description, professions, categories, poster];
}
