import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String location;
  final String contact;
  final String email;
  final String profession;
  final String profilePictureUrl; // Added field for profile picture URL

  ProfileLoaded({
    required this.name,
    required this.location,
    required this.contact,
    required this.email,
    required this.profession,
    required this.profilePictureUrl, // Required parameter for profile picture
  });

  @override
  List<Object> get props =>
      [name, location, contact, email, profession, profilePictureUrl];
}

class ProfileError extends ProfileState {
  final String error;

  const ProfileError(this.error);

  @override
  List<Object> get props => [error];
}

class ProfilePictureUploading extends ProfileState {}

class ProfilePictureUploaded extends ProfileState {
  final String profilePictureUrl;

  const ProfilePictureUploaded(this.profilePictureUrl);
}

class ProfilePictureError extends ProfileState {
  final String message;

  const ProfilePictureError(this.message);
}
