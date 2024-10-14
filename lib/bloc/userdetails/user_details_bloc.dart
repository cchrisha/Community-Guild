// user_details_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_details_event.dart';
import 'user_details_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  UserDetailsBloc() : super(UserDetailsInitial());

  @override
  Stream<UserDetailsState> mapEventToState(UserDetailsEvent event) async* {
    if (event is LoadUserDetails) {
      yield UserDetailsLoading();
      try {
        final response = await http.get(Uri.parse('https://api-tau-plum.vercel.app/api/users/${event.posterName}'));
        
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          if (data['status'] == 'success') {
            yield UserDetailsLoaded(data['data']);
          } else {
            yield UserDetailsError(data['message']);
          }
        } else {
          yield UserDetailsError('Failed to load user details: ${response.reasonPhrase}');
        }
      } catch (e) {
        yield UserDetailsError('An error occurred: $e');
      }
    }
  }
}
