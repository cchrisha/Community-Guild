// forget_password_event.dart
import 'package:equatable/equatable.dart';

abstract class ForgetPasswordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends ForgetPasswordEvent {
  final String email;
  SendOtpEvent({required this.email});
}

class VerifyOtpEvent extends ForgetPasswordEvent {
  final String otp;
  VerifyOtpEvent({required this.otp});
}

class ResetPasswordEvent extends ForgetPasswordEvent {
  final String password;
  ResetPasswordEvent({required this.password});
}
