import 'dart:convert';

// Assuming you have a User model for the job poster
class Job {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime datePosted;
  final String wageRange;
  final List<String> categories;
  final bool isCrypto;
  final List<String> professions;
  final User poster; // This represents the person who posted the job

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.datePosted,
    required this.wageRange,
    required this.categories,
    required this.isCrypto,
    required this.professions,
    required this.poster, // Initialize the poster field
  });

  factory Job.fromJson(Map<String, dynamic> json) {
  try {
    return Job(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      datePosted: DateTime.parse(json['datePosted']),
      wageRange: json['wageRange'],
      categories: List<String>.from(json['categories']),
      isCrypto: json['isCrypto'],
      professions: List<String>.from(json['professions']),
      poster: User.fromJson(json['poster']),
    );
  } catch (e) {
    print('Error parsing job JSON: $e');
    throw Exception('Failed to parse job');
  }
}


  // Convert Job object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'datePosted': datePosted.toIso8601String(),
      'wageRange': wageRange,
      'categories': categories,
      'isCrypto': isCrypto,
      'professions': professions,
      'poster': poster.toJson(), // Convert poster to JSON
    };
  }
}

// User class that represents the poster (assumed)
class User {
  final String name;
  final String email;

  User({
    required this.name,
    required this.email,
  });

  // Factory method to convert JSON to User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
}
