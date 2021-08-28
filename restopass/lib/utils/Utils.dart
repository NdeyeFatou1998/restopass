import 'package:flutter/material.dart';
import 'package:restopass/models/User.dart';
import 'package:restopass/utils/SharedPref.dart';
import 'package:restopass/utils/Widget.dart';
import 'package:restopass/views/LoginPage.dart';

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
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => LoginPage()));
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
