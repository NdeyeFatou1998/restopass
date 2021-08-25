import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restopass/models/LoginData.dart';
import 'package:restopass/utils/Utils.dart';

abstract class Request {
  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<http.Response> login(LoginData data) async {
    var uri = Uri.parse(API + '/etudiant/login');

    var client = new http.Client();

    return await client.post(uri,
        body: json.encode({'email': data.email, 'password': data.password}),
        headers: headers);
  }
}
