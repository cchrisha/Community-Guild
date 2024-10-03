import 'package:bloc/bloc.dart';
import 'logout_event.dart';
import 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  LogoutBloc() : super(LogoutInitial());

  Stream<LogoutState> mapEventToState(LogoutEvent event) async* {
    if (event is LogoutRequested) {
      yield LogoutLoading();
      try {
        // Simulate logout process (call your logout API or authentication method here)
        await Future.delayed(const Duration(seconds: 2));

        // If successful, yield LogoutSuccess
        yield LogoutSuccess();
      } catch (error) {
        // If there is an error, yield LogoutFailure with the error message
        yield LogoutFailure('Logout failed. Please try again.');
      }
    }
  }
}
