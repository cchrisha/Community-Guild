import 'package:community_guild/repository/logout_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logout_event.dart';
import 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutRepository logoutRepository;

  LogoutBloc(this.logoutRepository) : super(LogoutInitial()) {
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<LogoutState> emit) async {
    emit(LogoutLoading());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      print('Token retrieved for logout: $token');

      if (token != null) {
        await logoutRepository.logout(token);
        emit(LogoutSuccess());
      } else {
        emit(LogoutFailure('No token found.'));
      }
    } catch (error) {
      emit(LogoutFailure('Logout failed: ${error.toString()}'));
    }
  }
}
