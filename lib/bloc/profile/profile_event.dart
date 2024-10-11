import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {}

class VerifyAccount extends ProfileEvent {}

class ChangeProfilePicture extends ProfileEvent {
  final File newProfileImage;

  const ChangeProfilePicture(this.newProfileImage);

  @override
  List<Object> get props => [newProfileImage];
}
