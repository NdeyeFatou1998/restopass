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
