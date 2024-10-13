abstract class AboutJobEvent {}

class FetchAboutJobsByStatus extends AboutJobEvent {
  final String status;
  FetchAboutJobsByStatus(this.status);
}

class FetchJobsPostedByUser extends AboutJobEvent {
  final String userId;
  FetchJobsPostedByUser(this.userId);
}

