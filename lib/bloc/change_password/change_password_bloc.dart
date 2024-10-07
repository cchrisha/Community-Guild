// lib/bloc/change_password/bloc/change_password_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'change_password_event.dart';
import 'change_password_state.dart';
import 'package:community_guild/repository/change_password_repository.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordRepository changePasswordRepository;

  ChangePasswordBloc({required this.changePasswordRepository})
      : super(ChangePasswordInitial()) {
    on<ChangePasswordRequested>((event, emit) async {
      emit(ChangePasswordLoading());
      try {
        await changePasswordRepository.changePassword(
          event.oldPassword,
          event.newPassword,
          event.confirmPassword,
        );
        emit(ChangePasswordSuccess());
      } catch (error) {
        emit(ChangePasswordFailure(error: error.toString()));
      }
    });
  }
}
