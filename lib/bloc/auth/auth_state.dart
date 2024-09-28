import 'package:equatable/equatable.dart';

// AuthState: Represents the current state of the authentication process.
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);

  @override
  List<Object> get props => [error];
}

class PasswordVisibilityToggled extends AuthState {
  final bool obscureText;

  PasswordVisibilityToggled(this.obscureText);

  @override
  List<Object> get props => [obscureText];
}
