class Job {
  final String id;
  final String title;
  final String? wageRange;
  final bool isCrypto;
  final String location;
  final DateTime datePosted;
  final String? description;
  final List<String> professions;
  final List<String>? categories;
  final String? posterName;
  final String? posterId; // Add posterId property

  Job({
    required this.id,
    required this.title,
    this.wageRange,
    required this.isCrypto,
    required this.location,
    required this.datePosted,
    this.description,
    required this.professions,
    this.categories,
    this.posterName,
    this.posterId, // Include posterId in the constructor
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['_id'],
      title: json['title'],
      wageRange: json['wageRange'] as String?,
      isCrypto: json['isCrypto'],
      location: json['location'],
      datePosted: DateTime.parse(json['datePosted']),
      description: json['description'] as String?,
      professions: List<String>.from(json['professions'] ?? []),
      categories: json['categories'] != null
          ? List<String>.from(json['categories'])
          : null,
      posterName: json['poster'] != null ? json['poster']['name'] as String? : null,
      posterId: json['poster'] != null ? json['poster']['id'] as String? : null, // Update this to match your API response
    );
  }
}
