// user_details_event.dart

abstract class UserDetailsEvent {}

class LoadUserDetails extends UserDetailsEvent {
  final String posterName;

  LoadUserDetails(this.posterName);
}
