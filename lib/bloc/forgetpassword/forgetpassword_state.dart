// forget_password_state.dart
import 'package:equatable/equatable.dart';

abstract class ForgetPasswordState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ForgetPasswordInitial extends ForgetPasswordState {}

class OtpSending extends ForgetPasswordState {}

class OtpSent extends ForgetPasswordState {}

class OtpVerificationLoading extends ForgetPasswordState {}

class OtpVerified extends ForgetPasswordState {}

class PasswordResetLoading extends ForgetPasswordState {}

class PasswordResetSuccess extends ForgetPasswordState {}

class ForgetPasswordFailure extends ForgetPasswordState {
  final String error;
  ForgetPasswordFailure({required this.error});
}
