abstract class ProfilePictureState {}

class ProfilePictureInitial extends ProfilePictureState {}

class ProfilePictureUploading extends ProfilePictureState {}

class ProfilePictureUploaded extends ProfilePictureState {
  final String profilePictureUrl;

  ProfilePictureUploaded(this.profilePictureUrl);
}

class ProfilePictureError extends ProfilePictureState {
  final String message;

  ProfilePictureError(this.message);
}
