import 'package:equatable/equatable.dart';

abstract class ForgetPasswordEvent extends Equatable {
  const ForgetPasswordEvent();

  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends ForgetPasswordEvent {
  final String email;

  const SendOtpEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class VerifyOtpEvent extends ForgetPasswordEvent {
  final String email;
  final String otp;
  final String newPassword;

  const VerifyOtpEvent({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, otp, newPassword];
}

class ResetPasswordEvent extends ForgetPasswordEvent {
  final String email;
  final String newPassword;

  const ResetPasswordEvent({
    required this.email,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, newPassword];
}
