import 'package:equatable/equatable.dart';

abstract class JobEvent extends Equatable {
  const JobEvent();

  @override
  List<Object> get props => [];
}

class FetchJobDetail extends JobEvent {
  final int jobId;

  const FetchJobDetail(this.jobId);

  @override
  List<Object> get props => [jobId];
}
