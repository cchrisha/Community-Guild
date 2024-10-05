import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<FetchJobs>((event, emit) async {
      emit(HomeLoading());

      try {
        // Simulate an API call (replace with actual API call later)
        await Future.delayed(const Duration(seconds: 2));

        // Simulating no jobs returned by API
        List<dynamic> jobs = []; // Empty list to simulate no jobs in database

        emit(HomeLoaded(jobs));
      } catch (e) {
        emit(HomeError('Failed to load jobs.'));
      }
    });
  }
}
