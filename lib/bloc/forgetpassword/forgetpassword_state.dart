import 'package:equatable/equatable.dart';

abstract class ForgetPasswordState extends Equatable {
  const ForgetPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgetPasswordInitial extends ForgetPasswordState {}

class SendingOtpState extends ForgetPasswordState {}

class OtpSentState extends ForgetPasswordState {
  final String message;
  const OtpSentState(this.message);
}

class OtpVerificationLoading extends ForgetPasswordState {}

class OtpVerified extends ForgetPasswordState {
  final String message;
  const OtpVerified(this.message);
}

class PasswordResetLoading extends ForgetPasswordState {}

class PasswordResetSuccess extends ForgetPasswordState {
  final String message;
  const PasswordResetSuccess(this.message);
}

class ForgetPasswordFailure extends ForgetPasswordState {
  final String error;
  const ForgetPasswordFailure(this.error);

  @override
  List<Object?> get props => [error];
}
