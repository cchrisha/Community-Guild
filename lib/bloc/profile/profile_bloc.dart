import 'package:community_guild/repository/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<VerifyAccount>(_onVerifyAccount);
    on<UploadProfilePicture>(_onUploadProfilePicture); // Added event handler for uploading profile picture
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final data = await profileRepository.fetchProfile();
      emit(ProfileLoaded(
        name: data['name'] ?? 'N/A',
        location: data['location'] ?? 'N/A',
        contact: data['contact'] ?? 'N/A',
        email: data['email'] ?? 'N/A',
        profession: data['profession'] ?? 'N/A',
        profilePictureUrl: data['profilePictureUrl'] ?? 'N/A', // Added profile picture URL
      ));
    } catch (e) {
      emit(ProfileError('Failed to load profile: $e'));
    }
  }

  void _onVerifyAccount(VerifyAccount event, Emitter<ProfileState> emit) {
    // Implement account verification logic here
  }

  Future<void> _onUploadProfilePicture(
      UploadProfilePicture event, Emitter<ProfileState> emit) async {
    emit(ProfilePictureUploading());
    try {
      final url = await profileRepository.uploadProfilePicture(event.profileImage);
      emit(ProfilePictureUploaded(url));
      // Optionally, you can also refresh the profile after uploading
      add(LoadProfile()); // Reload profile after picture upload
    } catch (e) {
      emit(ProfilePictureError(e.toString()));
    }
  }
}
