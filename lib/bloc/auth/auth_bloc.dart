import 'package:community_guild/bloc/auth/auth_event.dart';
import 'package:community_guild/bloc/auth/auth_state.dart';
import 'package:community_guild/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  bool obscureText = true;
  bool obscureConfirmPassword = true;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    _checkAuthStatus();

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
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
        await authRepository.registerUser(
          event.userauth.name,
          event.userauth.email,
          event.userauth.password,
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }

  bool _isValidEmail(String email) {
    return email.contains('@');
  }
}
