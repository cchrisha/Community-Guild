// user_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'user_detail_event.dart';
import 'user_detail_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserLoading()) {
    on<FetchUserDetails>(_onFetchUserDetails);
  }

  Future<void> _onFetchUserDetails(
      FetchUserDetails event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final response = await http.get(Uri.parse(
          'https://api-tau-plum.vercel.app/api/users/${event.posterName}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          emit(UserLoaded(data['data']));
        } else {
          emit(UserError(data['message']));
        }
      } else {
        emit(UserError('Failed to load user details'));
      }
    } catch (e) {
      emit(UserError('An error occurred: $e'));
    }
  }
}
