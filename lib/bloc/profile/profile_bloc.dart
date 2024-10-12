import 'package:community_guild/repository/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<VerifyAccount>(_onVerifyAccount);
    on<ChangeProfilePicture>(
        _onChangeProfilePicture); // Add the event handler here
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final data = await profileRepository.fetchProfile();
      // Include profilePictureUrl in the emitted ProfileLoaded state
      emit(ProfileLoaded(
        name: data['name'] ?? 'N/A',
        location: data['location'] ?? 'N/A',
        contact: data['contact'] ?? 'N/A',
        email: data['email'] ?? 'N/A',
        profession: data['profession'] ?? 'N/A',
        profilePictureUrl: data['profilePicture'] ?? '', // Update this line
      ));
    } catch (e) {
      emit(ProfileError('Failed to load profile: $e'));
    }
  }

  void _onVerifyAccount(VerifyAccount event, Emitter<ProfileState> emit) {
    // Implement account verification logic here
  }

  void _onChangeProfilePicture(
      ChangeProfilePicture event, Emitter<ProfileState> emit) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileLoading()); // Show loading state

      try {
        // Call your repository to upload the image
        final imageUrl =
            await profileRepository.uploadImage(event.newProfileImage);

        // Emit a new state with the updated profile picture URL
        emit(ProfileLoaded(
          name: currentState.name,
          location: currentState.location,
          contact: currentState.contact,
          email: currentState.email,
          profession: currentState.profession,
          profilePictureUrl: imageUrl, // Update the profile picture URL
        ));
      } catch (e) {
        emit(ProfileError('Failed to update profile picture: $e'));
      }
    }
  }
}
