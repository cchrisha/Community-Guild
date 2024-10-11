import 'dart:io';

abstract class ProfilePictureEvent {}

class UploadProfilePicture extends ProfilePictureEvent {
  final File profileImage;

  UploadProfilePicture(this.profileImage);
}

class FetchProfilePicture extends ProfilePictureEvent {}
