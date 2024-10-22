import 'package:community_guild/repository/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    // Load, Verify, and Upload Profile
    on<LoadProfile>(_onLoadProfile);
    on<UploadProfilePicture>(_onUploadProfilePicture);
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

}
