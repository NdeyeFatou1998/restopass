import 'package:flutter/material.dart';
import 'package:restopass/utils/Utils.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

Widget spinner(Color color, double size) {
  return SleekCircularSlider(
    initialValue: 20,
    max: 90,
    appearance: CircularSliderAppearance(
        angleRange: 360,
        spinnerMode: true,
        startAngle: 90,
        size: size,
        customColors: CustomSliderColors(
          hideShadow: true,
          progressBarColor: color,
        )),
  );
}

Widget submitButton(String text, {required void Function()? onPressed}) {
  return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(10),
            backgroundColor: MaterialStateProperty.all(PRIMARY_COLOR)),
      ));
}
