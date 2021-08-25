import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restovigil/models/LoginError.dart';

import 'package:restovigil/models/LoginResponse.dart';
import 'package:restovigil/models/ScannerResponse.dart';
import 'package:restovigil/models/Tarif.dart';
import 'package:restovigil/utils/SharedPref.dart';
import 'package:restovigil/utils/Utils.dart';

class Request {
  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<http.Response> login(String? qr) async {
    var uri = Uri.parse(API + '/vigil/login');

    var client = new http.Client();

    return await client.post(uri,
        body: json.encode({'matricule': qr, 'password': PASS}),
        headers: headers);
  }

  static Future<List<Tarif>?> getTarifs(BuildContext context) async {
    var uri = Uri.parse(API + '/tarifs');
    String? token = await SharedPref.getToken();
    if (token == null) {
      logOut(context);
    }

    var client = new http.Client();

    var hdrs = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token!
    };
    var response = await client.get(uri, headers: hdrs);
    if (response.statusCode == 200) {
      return tarifsFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<ScannerResponse?> scan(
      BuildContext context, String compte, int tarif) async {
    var uri = Uri.parse(API + '/vigil/scanner');
    String? token = await SharedPref.getToken();
    if (token == null) {
      logOut(context);
    }

    var client = new http.Client();

    var hdrs = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token!
    };
    var body = json.encode({'compte': compte, 'tarif': tarif});
    var response = await client.post(uri, body: body, headers: hdrs);
    print(response.body);
    if (response.statusCode == 200 ||
        response.statusCode == 404 ||
        response.statusCode == 400) {
      return scannerResponseFromJson(response.body);
    } else {
      return null;
    }
  }
}

class AuthException implements Exception {
  late int _error;
  late String _message;

  AuthException(this._message, this._error);

  int get error => _error;
  String get message => _message;
}
