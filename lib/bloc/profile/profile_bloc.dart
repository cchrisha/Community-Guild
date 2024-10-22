import 'package:community_guild/repository/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    // Load, Verify, and Upload Profile
    on<LoadProfile>(_onLoadProfile);
    on<VerifyAccount>(_onVerifyAccount);
    on<UploadProfilePicture>(_onUploadProfilePicture);
    on<SendVerificationRequest>(_onSendVerificationRequest); // Add this line
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final data = await profileRepository.fetchProfile();
      final profilePictureUrl = await profileRepository.fetchProfilePicture(); // Fetch profile picture
      
      // Determine verification status based on isVerify value
      final isVerified = data['isVerify'] == 1; // 1 means verified, 0 means not verified

      emit(ProfileLoaded(
        name: data['name'] ?? 'N/A',
        location: data['location'] ?? 'N/A',
        contact: data['contact'] ?? 'N/A',
        email: data['email'] ?? 'N/A',
        profession: data['profession'] ?? 'N/A',
        profilePictureUrl: profilePictureUrl,
        isVerified: isVerified, // Include verification status
      ));
    } catch (e) {
      emit(ProfileError('Failed to load profile: $e'));
    }
  }

  // Implement account verification logic here
  void _onVerifyAccount(VerifyAccount event, Emitter<ProfileState> emit) {
    // This method is a placeholder for any future verification logic you might have.
  }

  Future<void> _onUploadProfilePicture(
      UploadProfilePicture event, Emitter<ProfileState> emit) async {
    emit(ProfilePictureUploading());
    try {
      final url =
          await profileRepository.uploadProfilePicture(event.profileImage);
      emit(ProfilePictureUploaded(url));
      add(LoadProfile());
    } catch (e) {
      emit(ProfilePictureError(e.toString()));
    }
  }

  // New event handler for sending verification requests
  Future<void> _onSendVerificationRequest(
    SendVerificationRequest event, Emitter<ProfileState> emit) async {
  emit(ProfileLoading());
  try {
    await profileRepository.sendVerificationRequest(); // Call to send verification request
    
    // After sending the request, fetch the updated profile
    final data = await profileRepository.fetchProfile();
    final profilePictureUrl = await profileRepository.fetchProfilePicture();

    // Determine verification status based on isVerify value
    final isVerified = data['isVerify'] == 1; // 1 means verified, 0 means not verified

    emit(ProfileLoaded(
      name: data['name'] ?? 'N/A',
      location: data['location'] ?? 'N/A',
      contact: data['contact'] ?? 'N/A',
      email: data['email'] ?? 'N/A',
      profession: data['profession'] ?? 'N/A',
      profilePictureUrl: profilePictureUrl,
      isVerified: isVerified, // Include verification status
    ));
  } catch (e) {
    emit(ProfileError('Failed to send verification request: $e'));
  }
}

}
