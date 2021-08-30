import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:restopass/models/Compte.dart';
import 'package:restopass/models/User.dart';

class SettingsPage extends StatefulWidget {
  User user;
  Compte compte;
  SettingsPage(this.user, this.compte, {Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return NeumorphicText(
      "I love flutter",
      style: NeumorphicStyle(
        depth: 4, //customize depth here
        color: Colors.white, //customize color here
      ),
      textStyle: NeumorphicTextStyle(
        fontSize: 18, //customize size here
        // AND others usual text style properties (fontFamily, fontWeight, ...)
      ),
    );
  }
}
