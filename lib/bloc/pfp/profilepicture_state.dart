abstract class ProfilePictureState {}

class ProfilePictureInitial extends ProfilePictureState {}

class ProfilePictureUploading extends ProfilePictureState {}

class ProfilePictureUploadSuccess extends ProfilePictureState {
  final String profileImageUrl;

  ProfilePictureUploadSuccess(this.profileImageUrl);
}

class ProfilePictureUploadFailure extends ProfilePictureState {
  final String error;

  ProfilePictureUploadFailure(this.error);
}
