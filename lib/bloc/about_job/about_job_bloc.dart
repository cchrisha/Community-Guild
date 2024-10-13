import 'package:community_guild/repository/all_job_detail/about_job_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'about_job_event.dart';
import 'about_job_state.dart';
//import 'about_job_repository.dart';

class AboutJobBloc extends Bloc<AboutJobEvent, AboutJobState> {
  final AboutJobRepository aboutJobRepository;

  AboutJobBloc(this.aboutJobRepository) : super(AboutJobInitial()) {
    on<FetchAboutJobsByStatus>((event, emit) async {
      emit(AboutJobLoading());
      try {
        // Fetch the jobs from the repository based on the status
        final jobs = await aboutJobRepository.fetchJobsByStatus(event.status);
        emit(AboutJobLoaded(jobs));
      } catch (error) {
        emit(AboutJobError(error.toString()));
      }
    });

    // Handle the new event for fetching jobs posted by the user
    on<FetchJobsPostedByUser>((event, emit) async {
      emit(AboutJobLoading());
      try {
        final jobs = await aboutJobRepository.fetchJobsPostedByUser(event.userId);
        emit(AboutJobLoaded(jobs));
      } catch (error) {
        emit(AboutJobError(error.toString()));
      }
    });

    on<FetchJobApplicants>((event, emit) async {
      emit(AboutJobApplicantsLoading());
      try {
        final applicants = await aboutJobRepository.fetchJobApplicants(event.jobId);
        emit(AboutJobApplicantsLoaded(applicants));
      } catch (error) {
        emit(AboutJobApplicantsError(error.toString()));
      }
    });
    
  }
}


