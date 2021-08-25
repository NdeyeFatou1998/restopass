import 'dart:convert';

import 'package:restopass/models/Compte.dart';
import 'package:restopass/models/User.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

class LoginResponse {
  late String token;
  late User user;
  late Compte compte;

  LoginResponse(
      {required this.token, required this.user, required this.compte});

  static LoginResponse fromJson(Map<String, dynamic> data) => LoginResponse(
      compte: compteFromJson(json.encode(data['compte'])),
      user: userFromJson(json.encode(data['user'])),
      token: data['token']);
}
