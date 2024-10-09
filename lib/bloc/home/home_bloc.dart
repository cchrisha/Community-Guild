import 'package:community_guild/repository/job_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final JobRepository jobRepository;

  HomeBloc({required this.jobRepository}) : super(HomeInitial()) {
    on<FetchJobs>((event, emit) async {
      emit(HomeLoading());

      try {
        // Fetch jobs using the repository
        final jobs = await jobRepository.getAllJobs();
        emit(HomeLoaded(jobs));
      } catch (e) {
        emit(HomeError('Failed to load jobs.'));
      }
    });
  }
}

