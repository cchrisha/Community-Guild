import 'package:community_guild/repository/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final ProfileRepository profileRepository; // Declare the repository

  EditProfileBloc({required this.profileRepository})
      : super(EditProfileInitial()) {
    // Register the event handler here
    on<SaveProfileEvent>(_mapSaveProfileEventToState);
  }

  // Event handler function for SaveProfileEvent
  Future<void> _mapSaveProfileEventToState(
      SaveProfileEvent event, Emitter<EditProfileState> emit) async {
    emit(EditProfileLoading()); // Indicate loading state

    try {
      // Call the repository to update user profile
      await profileRepository.updateUserProfile(
        name: event.name,
        location: event.location,
        contact: event.contact,
        profession: event.profession,
      );
      emit(EditProfileSaved(message: 'Profile saved successfully!'));
    } catch (error) {
      emit(EditProfileError(message: 'Failed to save profile: $error'));
    }
  }
}
