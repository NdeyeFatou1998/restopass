import 'package:flutter/material.dart';
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
    return Container();
  }
}
