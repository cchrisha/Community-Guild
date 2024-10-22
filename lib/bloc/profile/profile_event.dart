import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UploadProfilePicture extends ProfileEvent {
  final File profileImage;

  const UploadProfilePicture(this.profileImage);
}

class FetchProfilePicture extends ProfileEvent {}
