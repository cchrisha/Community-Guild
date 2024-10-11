import 'package:community_guild/repository/authentication/forgotpass_repository.dart';

import 'forgetpassword_event.dart';
import 'forgetpassword_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordBloc
    extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  final ForgetPasswordRepository repository;

  ForgetPasswordBloc({required this.repository})
      : super(ForgetPasswordInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResetPasswordEvent>(_onResetPassword);
  }

  void _onSendOtp(SendOtpEvent event, Emitter<ForgetPasswordState> emit) async {
    emit(SendingOtpState());
    try {
      final message = await repository.sendOtp(event.email);
      emit(OtpSentState(message));
    } catch (error) {
      emit(ForgetPasswordFailure(error.toString()));
    }
  }

  void _onVerifyOtp(
      VerifyOtpEvent event, Emitter<ForgetPasswordState> emit) async {
    emit(OtpVerificationLoading());
    try {
      final message = await repository.verifyOtp(event.email, event.otp);
      emit(OtpVerified(message));
    } catch (error) {
      emit(ForgetPasswordFailure(error.toString()));
    }
  }

  void _onResetPassword(
      ResetPasswordEvent event, Emitter<ForgetPasswordState> emit) async {
    emit(PasswordResetLoading());
    try {
      final message =
          await repository.resetPassword(event.email, event.newPassword);
      emit(PasswordResetSuccess(message));
    } catch (error) {
      emit(ForgetPasswordFailure(error.toString()));
    }
  }
}
