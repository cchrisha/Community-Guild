import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitJob extends PostEvent {
  final String title;
  final String location;
  final String profession;
  final String wageRange;
  final String contact;
  final String description;
  final bool isCrypto;

  SubmitJob({
    required this.title,
    required this.location,
    required this.profession,
    required this.wageRange,
    required this.contact,
    required this.description,
    required this.isCrypto,
    required String category,
  });

  @override
  List<Object?> get props =>
      [title, location, profession, wageRange, contact, description, isCrypto];
}
