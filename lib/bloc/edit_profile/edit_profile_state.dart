import 'package:equatable/equatable.dart';

abstract class EditProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class EditProfileInitial extends EditProfileState {}

class EditProfileSaved extends EditProfileState {
  final String message;

  EditProfileSaved({required this.message});

  @override
  List<Object> get props => [message];
}

class EditProfileError extends EditProfileState {
  final String message;

  EditProfileError({required this.message});

  @override
  List<Object> get props => [message];
}

class EditProfileLoading extends EditProfileState {}
