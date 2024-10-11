import 'package:community_guild/repository/all_job_detail/about_job_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'about_job_event.dart';
import 'about_job_state.dart';

class AboutJobBloc extends Bloc<AboutJobEvent, AboutJobState> {
  final AboutJobRepository aboutJobRepository; // Declare the repository

  // Correct constructor with the named parameter
  AboutJobBloc({required this.aboutJobRepository}) : super(JobInitial());

  Stream<AboutJobState> mapEventToState(AboutJobEvent event) async* {
    if (event is FetchCurrentJobs) {
      yield JobLoading();
      try {
        final jobs = await aboutJobRepository.fetchCurrentJobs();
        yield JobLoaded(jobs);
      } catch (e) {
        yield JobError(e.toString());
      }
    } else if (event is FetchCompletedJobs) {
      yield JobLoading();
      try {
        final jobs = await aboutJobRepository.fetchCompletedJobs();
        yield JobLoaded(jobs);
      } catch (e) {
        yield JobError(e.toString());
      }
    } else if (event is FetchRequestedJobs) {
      yield JobLoading();
      try {
        final jobs = await aboutJobRepository.fetchRequestedJobs();
        yield JobLoaded(jobs);
      } catch (e) {
        yield JobError(e.toString());
      }
    } else if (event is FetchRejectedJobs) {
      yield JobLoading();
      try {
        final jobs = await aboutJobRepository.fetchRejectedJobs();
        yield JobLoaded(jobs);
      } catch (e) {
        yield JobError(e.toString());
      }
    } else if (event is FetchPostedJobs) {
      yield JobLoading();
      try {
        final jobs = await aboutJobRepository.fetchPostedJobs();
        yield JobLoaded(jobs);
      } catch (e) {
        yield JobError(e.toString());
      }
    }
  }
}
