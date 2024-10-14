// user_details_state.dart

abstract class UserDetailsState {}

class UserDetailsInitial extends UserDetailsState {}

class UserDetailsLoading extends UserDetailsState {}

class UserDetailsLoaded extends UserDetailsState {
  final Map<String, dynamic> userDetails;

  UserDetailsLoaded(this.userDetails);
}

class UserDetailsError extends UserDetailsState {
  final String errorMessage;

  UserDetailsError(this.errorMessage);
}
