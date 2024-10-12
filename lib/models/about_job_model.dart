class AboutJobModel {
  final String id;
  final String title;
  final String wageRange;
  final bool isCrypto;
  final String location;
  final String description;
  final List<String> professions;
  final List<String> categories;
  final Poster poster;
  final String datePosted;
  final List<Request> requests;
  final List<Worker> workers;

  AboutJobModel({
    required this.id,
    required this.title,
    required this.wageRange,
    required this.isCrypto,
    required this.location,
    required this.description,
    required this.professions,
    required this.categories,
    required this.poster,
    required this.datePosted,
    required this.requests,
    required this.workers,
  });

  factory AboutJobModel.fromJson(Map<String, dynamic> json) {
    return AboutJobModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      wageRange: json['wageRange'] ?? '',
      isCrypto: json['isCrypto'] ?? false,
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      professions: List<String>.from(json['professions'] ?? []),
      categories: List<String>.from(json['categories'] ?? []),
      poster: Poster.fromJson(json['poster'] ?? {}),
      datePosted: json['datePosted'] ?? '',
      requests: (json['requests'] as List<dynamic>? ?? [])
          .map((request) => Request.fromJson(request as Map<String, dynamic>))
          .toList(),
      workers: (json['workers'] as List<dynamic>? ?? [])
          .map((worker) => Worker.fromJson(worker as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Poster {
  final String id;
  final String name;

  Poster({required this.id, required this.name});

  factory Poster.fromJson(Map<String, dynamic> json) {
    return Poster(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Request {
  final String userId;
  final String status;
  final String id;

  Request({required this.userId, required this.status, required this.id});

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      userId: json['user'] ?? '',
      status: json['status'] ?? '',
      id: json['_id'] ?? '',
    );
  }
}

class Worker {
  final String userId;
  final String status;
  final String id;

  Worker({required this.userId, required this.status, required this.id});

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      userId: json['user'] ?? '',
      status: json['status'] ?? '',
      id: json['_id'] ?? '',
    );
  }
}
