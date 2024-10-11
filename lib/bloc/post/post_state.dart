import 'package:equatable/equatable.dart';

abstract class PostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostSuccess extends PostState {}

class PostFailure extends PostState {
  final String message;

  PostFailure(this.message); // Take message as a positional parameter

  @override
  List<Object?> get props => [message];
}
