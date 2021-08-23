import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User user) => json.encode(user.toJson(user));

class User {
  late String name;
  late String email;
  late int id;
  late String matricule;
  String? imagePath;
  String? telephone;
  String? resto;
  int? restoId;

  User(
      {required this.name,
      required this.email,
      required this.id,
      required this.matricule,
      this.restoId,
      this.resto,
      this.imagePath,
      this.telephone});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        matricule: json["matricule"],
        resto: json["resto"],
        imagePath: json["image_path"],
        telephone: json["telephone"],
        restoId: json["resto_id"],
      );

  Map<String, dynamic> toJson(User user) => {
        "id": user.id,
        "name": user.name,
        "email": user.email,
        "image_path": user.imagePath,
        "matricule": user.matricule,
        "resto": user.resto,
        "telephone": user.telephone,
      };

  @override
  String toString() {
    return "USER: {id: $id,name: $name: email: $email: matricule: $matricule, resto: $resto, telephone: $telephone}";
  }
}
