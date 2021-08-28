import 'dart:convert';

import 'package:restopass/models/Compte.dart';
import 'package:restopass/models/User.dart';

RefreshResponse refreshResponseFromJson(String str) =>
    RefreshResponse.fromJson(json.decode(str));

class RefreshResponse {
  late User user;
  late Compte compte;

  RefreshResponse({required this.user, required this.compte});

  static RefreshResponse fromJson(Map<String, dynamic> data) => RefreshResponse(
        compte: compteFromJson(json.encode(data['compte'])),
        user: userFromJson(json.encode(data['user'])),
      );
}
