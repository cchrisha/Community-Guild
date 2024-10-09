import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:community_guild/models/job_model.dart';
import 'home_event.dart';
import 'home_state.dart';
import 'package:community_guild/repository/home_repository.dart';  // Import the HomeRepository

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;  // Change to HomeRepository

  HomeBloc(this.homeRepository) : super(HomeLoading()) {
    on<LoadJobs>((event, emit) async {
      try {
        final jobs = await homeRepository.getAllJobs();  // Fetch jobs from the HomeRepository
        if (jobs.isNotEmpty) {
          emit(HomeLoaded(jobs: jobs));
        } else {
          emit(HomeError("No jobs found"));
        }
      } catch (e) {
        print('Bloc error: $e');
        emit(HomeError("Failed to load jobs"));
      }
    });
  }
}
