// user_state.dart
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final Map<String, dynamic> userDetails;

  const UserLoaded(this.userDetails);

  @override
  List<Object?> get props => [userDetails];
}

class UserError extends UserState {
  final String errorMessage;

  const UserError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
