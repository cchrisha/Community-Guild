// forget_password_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'forgetpassword_event.dart';
import 'forgetpassword_state.dart';

class ForgetPasswordBloc
    extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  ForgetPasswordBloc() : super(ForgetPasswordInitial());

  @override
  Stream<ForgetPasswordState> mapEventToState(
      ForgetPasswordEvent event) async* {
    if (event is SendOtpEvent) {
      yield OtpSending();
      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));
        // Call your API service here
        yield OtpSent();
      } catch (error) {
        yield ForgetPasswordFailure(error: 'Failed to send OTP');
      }
    } else if (event is VerifyOtpEvent) {
      yield OtpVerificationLoading();
      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));
        if (event.otp == '123456') {
          // Replace this with actual OTP verification logic
          yield OtpVerified();
        } else {
          yield ForgetPasswordFailure(error: 'Invalid OTP');
        }
      } catch (error) {
        yield ForgetPasswordFailure(error: 'Failed to verify OTP');
      }
    } else if (event is ResetPasswordEvent) {
      yield PasswordResetLoading();
      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));
        // Call your API service here to reset the password
        yield PasswordResetSuccess();
      } catch (error) {
        yield ForgetPasswordFailure(error: 'Failed to reset password');
      }
    }
  }
}
