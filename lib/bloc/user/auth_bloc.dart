import 'package:community_guild/bloc/user/auth_event.dart';
import 'package:community_guild/bloc/user/auth_state.dart';
import 'package:community_guild/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  bool obscureText = true;
  bool obscureConfirmPassword = true;

  // Controllers for input fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final locationController = TextEditingController();
  final contactController = TextEditingController();
  final professionController = TextEditingController();
  final addinfoController = TextEditingController();

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    _checkAuthStatus();

    on<RegisterRequested>((event, emit) async {
  emit(AuthLoading());
  try {
    // Validate required fields
    if (event.userauth.name.isEmpty) {
      emit(AuthFailure('Name is required.'));
      return;
    }
    if (event.userauth.location.isEmpty) {
      emit(AuthFailure('Location is required.'));
      return;
    }
    if (event.userauth.contact.isEmpty) {
      emit(AuthFailure('Contact is required.'));
      return;
    }
    if (event.userauth.profession.isEmpty) {
      emit(AuthFailure('Profession is required.'));
      return;
    }
    if (event.userauth.addinfo.isEmpty) {
      emit(AuthFailure('Additional Info is required.'));
      return;
    }

    // Existing validations
    if (!_isValidEmail(event.userauth.email)) {
      emit(AuthFailure('Please enter a valid email address.'));
      return;
    }
    if (event.userauth.password.length < 4) {
      emit(AuthFailure('Password must be at least 4 characters long.'));
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      emit(AuthFailure('Passwords do not match.'));
      return;
    }

    // Proceed with registration
    await authRepository.registerUser(
      name: event.userauth.name,
      email: event.userauth.email,
      password: event.userauth.password,
      location: event.userauth.location,
      contact: event.userauth.contact,
      profession: event.userauth.profession,
      addinfo: event.userauth.addinfo,
      // walletAddress can be omitted as it's not required
    );

    emit(AuthSuccess());
  } catch (error) {
    emit(AuthFailure(error.toString()));
  }
});


    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        if (!_isValidEmail(event.email)) {
          emit(AuthFailure('Please enter a valid email address.'));
          return;
        }
        if (event.password.length < 4) {
          emit(AuthFailure('Password must be at least 4 characters long.'));
          return;
        }
        final token =
            await authRepository.loginUser(event.email, event.password);
        await authRepository.saveToken(token);
        emit(AuthSuccess());
      } catch (error) {
        emit(AuthFailure(error.toString()));
      }
    });

    on<TogglePasswordVisibility>((event, emit) {
      obscureText = !obscureText;
      emit(PasswordVisibilityToggled(obscureText));
    });

    on<ToggleConfirmPasswordVisibility>((event, emit) {
      obscureConfirmPassword = !obscureConfirmPassword; // Toggle visibility
      emit(ConfirmPasswordVisibilityToggled(
          obscureConfirmPassword)); // Emit new state
    });
  }

  Future<void> _checkAuthStatus() async {
    final token = await authRepository.getToken();
    if (token != null) {
      emit(AuthSuccess());
    } else {
      emit(AuthInitial());
    }
  }

  @override
  Future<void> close() {
    // Dispose all controllers
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    locationController.dispose();
    contactController.dispose();
    professionController.dispose();
    addinfoController.dispose();
    return super.close();
  }

  bool _isValidEmail(String email) {
    return email.contains('@');
  }
}
