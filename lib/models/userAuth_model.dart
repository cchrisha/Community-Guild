import 'package:equatable/equatable.dart';

class Userauth extends Equatable {
  final String id;
  final String name;
  final String email;
  final String password;
  final String walletAddress;
  final String location;
  final String contact;
  final String profession;

  const Userauth({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.walletAddress = '',
    required this.location,
    required this.contact,
    required this.profession,
  });

  factory Userauth.fromJson(Map<String, dynamic> json) {
    return Userauth(
        id: json['_id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        walletAddress: json['walletAddress'] ?? '',
        location: json['location'],
        contact: json['contact'],
        profession: json['profession']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'walletAddress': walletAddress,
      'location': location,
      'contact': contact,
      'profession': profession,
    };
  }

  @override
  List<Object> get props =>
      [id, name, email, password, walletAddress, location, contact, profession];
}
