import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:restovigil/models/LoginResponse.dart';
import 'package:restovigil/utils/Utils.dart';

class Request {
  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Map<String, String> _authorizationHeaders() {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Autorization': 'Bearer'
    };
  }

  static Future<http.Response> login(String? qr) async {
    var uri = Uri.parse(API + '/vigil/login');

    var client = new http.Client();

    return await client.post(uri,
        body: json.encode({'matricule': qr, 'password': PASS}),
        headers: headers);
  }
}
