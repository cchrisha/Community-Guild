class Job {
  final String id;
  final String title;
  final String? wageRange; // Nullable to handle possible null values
  final bool isCrypto;
  final String location;
  final DateTime datePosted;
  final String? description; // Nullable to handle possible null values
  final List<String> professions;
  final List<String>? categories; // Nullable to handle possible null values
  final String? posterName;

  Job({
    required this.id,
    required this.title,
    this.wageRange, // Nullable
    required this.isCrypto,
    required this.location,
    required this.datePosted,
    this.description, // Nullable
    required this.professions,
    this.categories, // Nullable
    this.posterName,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['_id'],
      title: json['title'],
      wageRange: json['wageRange'] as String?, // Handling null for wageRange
      isCrypto: json['isCrypto'],
      location: json['location'],
      datePosted: DateTime.parse(json['datePosted']),
      description: json['description'] as String?, // Handling null for description
      professions: List<String>.from(json['professions'] ?? []), // Ensure professions is a valid list
      categories: json['categories'] != null ? List<String>.from(json['categories']) : null, // Handling null for categories
      posterName: json['poster'] != null ? json['poster']['name'] as String? : null, // Handling null for poster
    );
  }
}
