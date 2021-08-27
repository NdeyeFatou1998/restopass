import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:restopass/models/LoginData.dart';
import 'package:restopass/models/Response.dart' as api;
import 'package:restopass/models/Tranfer.dart';
import 'package:restopass/utils/SharedPref.dart';
import 'package:restopass/utils/Utils.dart';

abstract class Request {
  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<http.Response?> login(LoginData data) async {
    var uri = Uri.parse(API + '/etudiant/login');

    var client = new http.Client();
    http.Response? response;
    try {
      response = await client.post(uri,
          body: json.encode({'email': data.email, 'password': data.password}),
          headers: headers);
    } on SocketException {
      response = null;
    }
    return response;
  }

  static Future<http.Response?> createPin(String pin) async {
    var uri = Uri.parse(API + '/etudiant/pin');
    String? token = await SharedPref.getToken();
    if (token == null) {
      return null;
    }

    var hdrs = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    var client = new http.Client();

    return await client.post(uri,
        body: json.encode({'pin': pin}), headers: hdrs);
  }

  static Future<List<Transfert>?> getTranferts() async {
    var uri = Uri.parse(API + '/etudiant/transfert');
    String? token = await SharedPref.getToken();

    if (token == null) {
      return null;
    }

    var hdrs = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    var client = new http.Client();
    late List<Transfert>? apiResponse;

    http.Response response = await client.get(uri, headers: hdrs);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      apiResponse = tranfertsFromJson(response.body);
    } else
      apiResponse = null;
    return apiResponse;
  }
}
