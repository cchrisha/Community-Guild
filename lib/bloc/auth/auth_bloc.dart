import 'dart:convert';
import 'package:community_guild/bloc/auth/auth_event.dart';
import 'package:community_guild/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final http.Client httpClient;
  bool obscureText = true;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  AuthBloc({required this.httpClient}) : super(AuthInitial()) {
    _checkAuthStatus(); // Check authentication status on app start.

    on<RegisterRequested>((event, emit) async {
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
        if (passwordController.text != confirmPasswordController.text) {
          emit(AuthFailure('Passwords do not match.'));
          return;
        }
        final response = await httpClient.post(
          Uri.parse('https://api-tau-plum.vercel.app/api/userSignup'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': event.name,
            'email': event.email,
            'password': event.password,
          }),
        );
        if (response.statusCode == 201) {
          emit(AuthSuccess());
        } else {
          emit(AuthFailure('Registration failed.'));
        }
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
        final response = await httpClient.post(
          Uri.parse('https://api-tau-plum.vercel.app/api/userLogin'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': event.email,
            'password': event.password,
          }),
        );
        if (response.statusCode == 200) {
          // Save token to SharedPreferences
          final token = json.decode(response.body)['token'];
          await _saveToken(token);
          emit(AuthSuccess());
        } else {
          emit(AuthFailure('Login failed.'));
        }
      } catch (error) {
        emit(AuthFailure(error.toString()));
      }
    });

    on<TogglePasswordVisibility>((event, emit) {
      obscureText = !obscureText;
      emit(PasswordVisibilityToggled(obscureText));
    });

    // on<LogoutRequested>((event, emit) async {
    //   await _clearToken(); // Clear token on logout
    //   emit(AuthInitial());
    // });
  }

  // Check if the user is authenticated
  Future<void> _checkAuthStatus() async {
    final token = await _getToken();
    if (token != null) {
      emit(AuthSuccess());
    } else {
      emit(AuthInitial());
    }
  }

  // Save token to SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Get token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Clear token from SharedPreferences
  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Helper function to validate email
  bool _isValidEmail(String email) {
    return email.contains('@');
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}


// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final http.Client httpClient;
//   bool obscureText = true;

//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();

//   AuthBloc({required this.httpClient}) : super(AuthInitial()) {
//     on<RegisterRequested>((event, emit) async {
//       emit(AuthLoading());
//       try {
//         if (!_isValidEmail(event.email)) {
//           emit(AuthFailure('Please enter a valid email address.'));
//           return;
//         }
//         if (event.password.length < 4) {
//           emit(AuthFailure('Password must be at least 4 characters long.'));
//           return;
//         }
//         if (passwordController.text != confirmPasswordController.text) {
//           emit(AuthFailure('Passwords do not match.'));
//           return;
//         }
//         final response = await httpClient.post(
//           Uri.parse('http://localhost:3001/api/userSignup'),
//           headers: {'Content-Type': 'application/json'},
//           body: json.encode({
//             'name': event.name,
//             'email': event.email,
//             'password': event.password,
//           }),
//         );
//         if (response.statusCode == 201) {
//           emit(AuthSuccess());
//         } else {
//           emit(AuthFailure('Registration failed.'));
//         }
//       } catch (error) {
//         emit(AuthFailure(error.toString()));
//       }
//     });

//     on<LoginRequested>((event, emit) async {
//       emit(AuthLoading());
//       try {
//         if (!_isValidEmail(event.email)) {
//           emit(AuthFailure('Please enter a valid email address.'));
//           return;
//         }
//         if (event.password.length < 4) {
//           emit(AuthFailure('Password must be at least 4 characters long.'));
//           return;
//         }
//         final response = await httpClient.post(
//           Uri.parse('http://localhost:3001/api/userLogin'),
//           headers: {'Content-Type': 'application/json'},
//           body: json.encode({
//             'email': event.email,
//             'password': event.password,
//           }),
//         );
//         if (response.statusCode == 200) {
//           emit(AuthSuccess());
//         } else {
//           emit(AuthFailure('Login failed.'));
//         }
//       } catch (error) {
//         emit(AuthFailure(error.toString()));
//       }
//     });

//     on<TogglePasswordVisibility>((event, emit) {
//       obscureText = !obscureText;
//       emit(PasswordVisibilityToggled(obscureText));
//     });
//   }

//   bool _isValidEmail(String email) {
//     return email.contains('@');
//   }

//   @override
//   Future<void> close() {
//     nameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     return super.close();
//   }
// }


// AuthEvent: Events that trigger state changes.
// abstract class AuthEvent extends Equatable {
//   @override
//   List<Object> get props => [];
// }

// class RegisterRequested extends AuthEvent {
//   final String name;
//   final String email;
//   final String password;
//   final String confirmPassword;

//   RegisterRequested(this.name, this.email, this.password, this.confirmPassword);

//   @override
//   List<Object> get props => [name, email, password, confirmPassword];
// }

// class LoginRequested extends AuthEvent {
//   final String email;
//   final String password;

//   LoginRequested(this.email, this.password);

//   @override
//   List<Object> get props => [email, password];
// }

// class TogglePasswordVisibility extends AuthEvent {}

// // AuthState: Represents the current state of the authentication process.
// abstract class AuthState extends Equatable {
//   @override
//   List<Object> get props => [];
// }

// class AuthInitial extends AuthState {}

// class AuthLoading extends AuthState {}

// class AuthSuccess extends AuthState {}

// class AuthFailure extends AuthState {
//   final String error;

//   AuthFailure(this.error);

//   @override
//   List<Object> get props => [error];
// }


// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   AuthBloc() : super(AuthInitial());

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();
//   bool obscureText = true;

//   Stream<AuthState> mapEventToState(AuthEvent event) async* {
//     if (event is LoginRequested) {
//       yield* _mapLoginRequestedToState(event);
//     } else if (event is RegisterRequested) {
//       yield* _mapRegisterRequestedToState(event);
//     } else if (event is TogglePasswordVisibility) {
//       yield* _mapTogglePasswordVisibilityToState();
//     }
//   }

//   Stream<AuthState> _mapLoginRequestedToState(LoginRequested event) async* {
//     try {
//       // Implement your login logic here
//       // Example: call an API to login
//       yield AuthSuccess();
//     } catch (e) {
//       yield AuthFailure(e.toString());
//     }
//   }

//   Stream<AuthState> _mapRegisterRequestedToState(
//       RegisterRequested event) async* {
//     try {
//       // Implement your registration logic here
//       // Example: call an API to register
//       yield AuthSuccess();
//     } catch (e) {
//       yield AuthFailure(e.toString());
//     }
//   }

//   Stream<AuthState> _mapTogglePasswordVisibilityToState() async* {
//     obscureText = !obscureText;
//     yield AuthInitial(); // Refresh UI
//   }
// }
