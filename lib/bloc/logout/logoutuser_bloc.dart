import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'logoutuser_event.dart';
part 'logoutuser_state.dart';

class LogoutuserBloc extends Bloc<LogoutuserEvent, LogoutuserState> {
  LogoutuserBloc() : super(LogoutuserInitial()) {
    on<LogoutuserEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
