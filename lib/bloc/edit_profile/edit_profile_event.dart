import 'package:equatable/equatable.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object?> get props => [];
}

class SaveProfileEvent extends EditProfileEvent {
  final String name;
  final String location;
  final String contact;
  final String profession;

  const SaveProfileEvent({
    required this.name,
    required this.location,
    required this.contact,
    required this.profession,
  });

  @override
  List<Object?> get props => [name, location, contact, profession];
}
