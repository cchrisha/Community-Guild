// user_event.dart
import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserDetails extends UserEvent {
  final String posterName;

  const FetchUserDetails(this.posterName);

  @override
  List<Object?> get props => [posterName];
}
