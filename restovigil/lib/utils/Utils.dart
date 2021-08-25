import 'package:flutter/material.dart';
import 'package:restovigil/models/LoginData.dart';
import 'package:restovigil/models/User.dart';
import 'package:restovigil/utils/SharedPref.dart';
import 'package:restovigil/views/HomePage.dart';
import 'package:restovigil/views/LoginPage.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

const String HOST = "http://192.168.43.228:8000";
const String HOST_ADRESS = "192.168.43.228";
const String API = "http://192.168.43.228:8000/api";
const int PORT = 8000;
const String APP_NAME = "Resto Vigil";
const Color PRIMARY_COLOR = Color(0xffFA1234);
const String PASS = "restopass.vigil";

// CODE EXCEPTION
final int UNAUTH = 401;

Widget progressBar(String message) {
  return Container(
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SleekCircularSlider(
          initialValue: 10,
          max: 100,
          appearance: CircularSliderAppearance(
              angleRange: 360,
              spinnerMode: true,
              startAngle: 90,
              size: 100,
              customColors: CustomSliderColors(
                hideShadow: true,
                progressBarColor: PRIMARY_COLOR,
              )),
        ),
        SizedBox(height: 20),
        Text(message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontFamily: "Poppins Light"))
      ],
    ),
  );
}

Future<User?> isLogin() async {
  return await SharedPref.getUser();
}

logOut(BuildContext context) async {
  await SharedPref.removeUser();
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => LoginPage()));
}

Widget onSuccess(BuildContext context, String message, Color color) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(Icons.check_circle_outline_outlined, color: color, size: 100),
      Text(message,
          style: TextStyle(
            color: color,
            fontSize: 15,
          ),
          textAlign: TextAlign.center),
    ],
  );
}

Widget onError(BuildContext context, String message) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(
        Icons.error_outline_rounded,
        color: Colors.red,
        size: 100,
      ),
      Text(message,
          style: TextStyle(
              color: Colors.red,
              fontSize: 15,
              fontFamily: "Poppin Light",
              fontWeight: FontWeight.w700),
          textAlign: TextAlign.center),
    ],
  );
}

Widget onInfo(BuildContext context, Color color, String message) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(Icons.info_outline_rounded, color: color, size: 100),
      Text(message,
          style: TextStyle(
            color: color,
            fontSize: 15,
          ),
          textAlign: TextAlign.center),
    ],
  );
}
