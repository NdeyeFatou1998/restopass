import 'dart:convert';

import 'package:restovigil/models/User.dart';

import 'Tarif.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

class LoginResponse {
  late String token;
  late User user;
  late List<Tarif> tarifs;

  LoginResponse(
      {required this.user, required this.token, required this.tarifs});

  static fromJson(Map<String, dynamic> data) => LoginResponse(
      tarifs: tarifsFromJson(json.encode(data['tarifs'])),
      user: userFromJson(json.encode(data['user'])),
      token: data['token']);
}
