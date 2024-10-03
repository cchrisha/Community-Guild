part of 'logoutuser_bloc.dart';

sealed class LogoutuserState extends Equatable {
  const LogoutuserState();
  
  @override
  List<Object> get props => [];
}

final class LogoutuserInitial extends LogoutuserState {}
