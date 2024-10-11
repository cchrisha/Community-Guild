class Job {
  final String jobTitle;
  final String jobDescription;
  final String workPlace;
  final String date;
  final String wageRange;
  final String contact;
  final String category;
  final bool isCrypto;
  final String professions;

  Job({
    required this.jobTitle,
    required this.jobDescription,
    required this.workPlace,
    required this.date,
    required this.wageRange,
    required this.contact,
    required this.category,
    required this.isCrypto,
    required this.professions,
  });

  // Method to map API data to Job model
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      jobTitle: json['jobTitle'],
      jobDescription: json['jobDescription'],
      workPlace: json['workPlace'],
      date: json['date'],
      wageRange: json['wageRange'],
      contact: json['contact'],
      category: json['category'],
      isCrypto: json['isCrypto'],
      professions: json['professions'],
    );
  }
}
