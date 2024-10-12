abstract class AboutJobEvent {}

class FetchAboutJobsByStatus extends AboutJobEvent {
  final String status;
  FetchAboutJobsByStatus(this.status);
}
