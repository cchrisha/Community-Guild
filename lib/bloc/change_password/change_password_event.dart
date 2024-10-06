// lib/bloc/change_password/bloc/change_password_event.dart
import 'package:equatable/equatable.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object?> get props => [];
}

class ChangePasswordRequested extends ChangePasswordEvent {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordRequested(
      {required this.oldPassword, required this.newPassword});

  @override
  List<Object?> get props => [oldPassword, newPassword];
}
