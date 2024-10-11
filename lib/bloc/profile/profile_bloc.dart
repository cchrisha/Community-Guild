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
      emit(ProfileLoaded(
        name: data['name'] ?? 'N/A',
        location: data['location'] ?? 'N/A',
        contact: data['contact'] ?? 'N/A',
        email: data['email'] ?? 'N/A',
        profession: data['profession'] ?? 'N/A',
      ));
    } catch (e) {
      emit(ProfileError('Failed to load profile: $e'));
    }
  }

  void _onVerifyAccount(VerifyAccount event, Emitter<ProfileState> emit) {
    // Implement account verification logic here
  }

  // Add the new event handler for changing the profile picture
  void _onChangeProfilePicture(
      ChangeProfilePicture event, Emitter<ProfileState> emit) {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileLoaded(
        name: currentState.name,
        location: currentState.location,
        contact: currentState.contact,
        email: currentState.email,
        profession: currentState.profession,
        profileImage: event.newProfileImage, // Update profile image
      ));
    }
  }
}
