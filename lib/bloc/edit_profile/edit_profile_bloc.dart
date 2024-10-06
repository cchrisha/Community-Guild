import 'package:flutter_bloc/flutter_bloc.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditProfileInitial());

  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is SaveProfileEvent) {
      yield* _mapSaveProfileEventToState(event);
    }
  }

  Stream<EditProfileState> _mapSaveProfileEventToState(
      SaveProfileEvent event) async* {
    try {
      // Here you can add the logic to save the profile data.
      // For example, sending the data to an API or saving it locally.
      yield EditProfileSaved(message: 'Profile saved successfully!');
    } catch (error) {
      yield EditProfileError(message: 'Failed to save profile: $error');
    }
  }
}
