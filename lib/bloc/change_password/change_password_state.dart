// lib/bloc/change_password/bloc/change_password_state.dart
import 'package:equatable/equatable.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object?> get props => [];
}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {}

class ChangePasswordFailure extends ChangePasswordState {
  final String error;

  const ChangePasswordFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
