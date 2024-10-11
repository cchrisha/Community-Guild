// lib/models/job.dart
class Job {
  final String title;
  final String description;
  final String workplace;
  final String date;
  final String wageRange;
  final String contact;
  final String category;
  final bool isCrypto;
  final String professions;

  Job({
    required this.title,
    required this.description,
    required this.workplace,
    required this.date,
    required this.wageRange,
    required this.contact,
    required this.category,
    required this.isCrypto,
    required this.professions,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      title: json['title'],
      description: json['description'],
      workplace: json['workplace'],
      date: json['date'],
      wageRange: json['wageRange'],
      contact: json['contact'],
      category: json['category'],
      isCrypto: json['isCrypto'],
      professions: json['professions'],
    );
  }
}
