import 'package:flutter/material.dart';
import 'package:restovigil/utils/SharedPref.dart';
import 'package:restovigil/views/HomePage.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

const String HOST = "http://192.168.43.228:8000";
const String HOST_ADRESS = "192.168.43.228";
const String API = "http://192.168.43.228:8000/api";
const int PORT = 8000;
const String APP_NAME = "Resto Vigil";
const Color PRIMARY_COLOR = Color(0xffFA1234);
const String PASS = "restopass.vigil";

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

Future isLogin(BuildContext context) async {
  bool test = await SharedPref.getUser() == null ? false : true;
  if (test) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
