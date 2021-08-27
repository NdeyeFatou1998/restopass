import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restopass/models/Compte.dart';
import 'package:restopass/models/User.dart';
import 'package:restopass/utils/SharedPref.dart';
import 'package:restopass/utils/Utils.dart';
import 'package:restopass/views/CodePinPage.dart';
import 'package:restopass/views/GivePinPage.dart';
import 'package:restopass/views/HomePage.dart';
import 'package:restopass/views/LoginPage.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () async {
      User? user = await isLogin();
      Compte? compte = await SharedPref.getCompte();
      String? pin = await SharedPref.getPin();
      print("USER::::::::" + user.toString());
      print("COMPTE::::::::" + compte.toString());
      if (user == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else if (compte != null && pin == null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => CodePinPage(user, compte)));
      } else if (compte != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => GivePinPage(user, compte)));
      }
    });
    return Scaffold(body: _splashScreen(context));
  }

  Widget _splashScreen(context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(APP_NAME,
              style: TextStyle(
                  color: PRIMARY_COLOR,
                  fontSize: 25,
                  fontFamily: "Poppins Light",
                  fontWeight: FontWeight.bold)),
          SleekCircularSlider(
            initialValue: 20,
            max: 90,
            appearance: CircularSliderAppearance(
                angleRange: 360,
                spinnerMode: true,
                startAngle: 90,
                size: 35,
                customColors: CustomSliderColors(
                  hideShadow: true,
                  progressBarColor: PRIMARY_COLOR,
                )),
          ),
        ],
      ),
    );
  }
}
