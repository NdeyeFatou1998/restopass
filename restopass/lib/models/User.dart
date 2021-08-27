import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

class User {
  late int id;
  late String matricule;
  late String firstName;
  late String lastName;
  late String email;
  late String? imagePath;

  User(
      {required this.id,
      required this.matricule,
      required this.firstName,
      required this.lastName,
      required this.email,
      this.imagePath});

  static User fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      matricule: json['matricule'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      imagePath: json['image_path']);

  @override
  String toString() {
    return "USER: id: $id, email: $email, name: $firstName $lastName,matricule: $matricule";
  }
}
