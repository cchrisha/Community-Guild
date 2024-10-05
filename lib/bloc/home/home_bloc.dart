import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<FetchJobs>((event, emit) async {
      emit(HomeLoading());

      try {
        // Simulating an API call for now
        await Future.delayed(
            const Duration(seconds: 2)); // Simulate network delay
        // Replace with actual API call
        List<dynamic> jobs = [
          {'title': 'Job 1', 'description': 'Description 1'},
          {'title': 'Job 2', 'description': 'Description 2'},
        ];

        emit(HomeLoaded(jobs));
      } catch (e) {
        emit(HomeError('Failed to load jobs'));
      }
    });
  }
}
