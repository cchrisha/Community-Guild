import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import 'package:community_guild/repository/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;

  HomeBloc({required this.homeRepository}) : super(HomeLoading()) {
    on<LoadJobs>(_onLoadJobs);
    on<SearchJobs>(_onSearchJobs); // Add the search event handler
  }

  // Event handler for loading jobs
  void _onLoadJobs(LoadJobs event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    try {
      final recommendedJobs = await homeRepository.getRecommendedJobs();
      final recentJobs = await homeRepository.getMostRecentJobs();
      emit(
          HomeLoaded(recommendedJobs: recommendedJobs, recentJobs: recentJobs));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  // Event handler for searching jobs
  void _onSearchJobs(SearchJobs event, Emitter<HomeState> emit) async {
    // Check if the search query is empty, prevent searching in this case
    if (event.query.isEmpty) return;

    emit(HomeLoading());

    try {
      final allJobs =
          await homeRepository.getAllJobs(); // Ensure this method exists
      final filteredJobs = allJobs.where((job) {
        return job.title.toLowerCase().contains(event.query.toLowerCase()) ||
            (job.description
                    ?.toLowerCase()
                    .contains(event.query.toLowerCase()) ??
                false);
      }).toList();

      // Assuming you want to display the filtered jobs in both recommended and recent lists
      emit(HomeLoaded(recommendedJobs: filteredJobs, recentJobs: filteredJobs));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}
