import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String location;
  final String contact;
  final String email;
  final String profession;

  ProfileLoaded({
    required this.location,
    required this.contact,
    required this.email,
    required this.profession,
  });

  @override
  List<Object> get props => [location, contact, email, profession];
}

class ProfileError extends ProfileState {
  final String error;

  const ProfileError(this.error);

  @override
  List<Object> get props => [error];
}
