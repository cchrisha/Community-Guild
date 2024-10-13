// import 'package:bloc/bloc.dart';
// import '../../repository/all_job_detail/job_repository.dart';
// import 'job_detail_event.dart';
// import 'job_detail_state.dart';

// class JobBloc extends Bloc<JobEvent, JobState> {
//   final JobRepository jobRepository;

// //   JobBloc(this.jobRepository) : super(JobInitial()) {
// //     on<FetchJobDetail>((event, emit) async {
// //       emit(JobLoading());
// //       try {
// //         final job = await jobRepository.fetchJobDetail(event.jobId);
// //         emit(JobLoaded(job));
// //       } catch (e) {
// //         emit(JobError(e.toString()));
// //       }
// //     });
// //   }
// // }
