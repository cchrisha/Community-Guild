import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    // Add the event handler for LoadProfile and other events
    on<LoadProfile>(_onLoadProfile);
    on<VerifyAccount>(_onVerifyAccount);
  }

  // This method handles the LoadProfile event
  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      // Simulate profile loading (replace this with your actual API call)
      await Future.delayed(const Duration(seconds: 1));
      emit(const ProfileLoaded(
          location: '', contact: '', email: '', profession: ''));
    } catch (e) {
      emit(const ProfileError('Failed to load profile'));
    }
  }

  // This method handles the VerifyAccount event (placeholder for now)
  void _onVerifyAccount(VerifyAccount event, Emitter<ProfileState> emit) {
    // Implement account verification logic here
  }
}
