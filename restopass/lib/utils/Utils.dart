import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:restopass/models/LoginResponse.dart';
import 'package:restopass/models/User.dart';
import 'package:restopass/utils/SharedPref.dart';
import 'package:restopass/views/CodePinPage.dart';
import 'package:restopass/views/GivePinPage.dart';

const String HOST = "http://192.168.43.228:8000";
const String HOST_ADRESS = "192.168.43.228";
const String API = "http://192.168.43.228:8000/api";
const int PORT = 8000;
const String APP_NAME = "Resto Pass";
const Color PRIMARY_COLOR = Color(0xFF5C01CA);
const Color PRIMARY_COLOR_F1 = Color(0xF55C01CA);
const Color SECONDARY_COLOR = Color(0xFFF1E6FF);
const String PASS = "restopass.vigil";

// CODE EXCEPTION
final int UNAUTH = 401;

Future<User?> isLogin() async {
  return await SharedPref.getUser();
}

logOut(BuildContext context) async {
  await SharedPref.removeUser();
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
}

toast(BuildContext context, Color color, String message, {int time = 3}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  FocusScope.of(context).unfocus();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      elevation: 8.0,
      duration: Duration(seconds: time),
      content: Text(message),
      action: SnackBarAction(
        label: 'Fermer',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}

bool isMail(String str) {
  return RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
      .hasMatch(str);
}

bool emailValidator(String? email) {
  if (email == null || email.isEmpty || !isMail(email)) {
    return false;
  }
  log("EMAIL: $email");
  return true;
}

bool codeValidator(String? code) {
  if (code == null || code.isEmpty || code.length != 8) {
    return false;
  }
  log("CODE: $code");
  return true;
}

bool passwordValidator(String? password) {
  if (password == null || password.isEmpty || password.length < 6) {
    return false;
  }
  log("PASSWORD: $password");
  return true;
}

String parseCode(String code) {
  String realCode = '';
  for (var item in code.split('-')) {
    realCode += item;
  }
  log("REAL CODE: " + realCode);
  return realCode;
}

void afterAuth(Response result, BuildContext context) async {
  LoginResponse res = loginResponseFromJson(result.body);
  await SharedPref.saveUser(res.user);
  await SharedPref.setCompte(res.compte);
  await SharedPref.setToken(res.token);
  if (res.compte.pin == null) {
    // creer un nouveau pin
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => CodePinPage(res.user, res.compte)),
        (Route<dynamic> route) => false);
  } else if (res.compte.pin != null) {
    // donner son pin
    await SharedPref.setPin(res.compte.pin ?? '');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => GivePinPage(res.user, res.compte)),
        (Route<dynamic> route) => false);
  }
}

Future messageDialog(BuildContext context, String s) async {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        content: Container(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: Icon(
                      Icons.check_circle_outline_rounded,
                      color: Colors.green,
                      size: 40,
                    )),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    s,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins Light',
                        fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )),
        actions: <Widget>[
          TextButton(
            child: Text("Merci",
                style: TextStyle(
                  color: Colors.black,
                )),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

Future<bool?> confDialog(BuildContext context,
    {required String title, required String message}) async {
  return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Confirmation"),
            content: Text("Voulez-vous vous déconnecter?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text("Non", style: TextStyle(color: PRIMARY_COLOR)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text("Oui", style: TextStyle(color: PRIMARY_COLOR)),
              )
            ],
            elevation: 25.0,
          ));
}
