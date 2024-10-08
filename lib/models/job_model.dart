class Job {
  final String id;
  final String title;
  final String wageRange;
  final bool isCrypto;
  final String location;
  final DateTime datePosted;
  final String description;
  final List<String> professions;
  final List<String> categories;
  final String poster;

  Job({
    required this.id,
    required this.title,
    required this.wageRange,
    required this.isCrypto,
    required this.location,
    required this.datePosted,
    required this.description,
    required this.professions,
    required this.categories,
    required this.poster,
  });

  // From JSON
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['_id'],
      title: json['title'],
      wageRange: json['wageRange'],
      isCrypto: json['isCrypto'],
      location: json['location'],
      datePosted: DateTime.parse(json['datePosted']),
      description: json['description'],
      professions: List<String>.from(json['professions']),
      categories: List<String>.from(json['categories']),
      poster: json['poster'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'wageRange': wageRange,
      'isCrypto': isCrypto,
      'location': location,
      'datePosted': datePosted.toIso8601String(),
      'description': description,
      'professions': professions,
      'categories': categories,
      'poster': poster,
    };
  }
}
