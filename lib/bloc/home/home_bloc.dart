import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import 'package:community_guild/repository/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;

  HomeBloc({required this.homeRepository}) : super(HomeLoading()) {
    on<LoadJobs>(_onLoadJobs);
  }

  void _onLoadJobs(LoadJobs event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    try {
      final recommendedJobs = await homeRepository.getRecommendedJobs(event.profession);
      final recentJobs = await homeRepository.getMostRecentJobs();
      emit(HomeLoaded(recommendedJobs: recommendedJobs, recentJobs: recentJobs));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}
