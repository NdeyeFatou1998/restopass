import 'package:flutter/material.dart';
import 'package:restopass/models/User.dart';
import 'package:restopass/utils/Utils.dart';
import 'package:restopass/views/HomePage.dart';
import 'package:restopass/views/LoginPage.dart';

class HomeOrLoginPage extends StatefulWidget {
  User? user;
  HomeOrLoginPage(this.user, {Key? key}) : super(key: key);

  @override
  _HomeOrLoginPageState createState() => _HomeOrLoginPageState();
}

class _HomeOrLoginPageState extends State<HomeOrLoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.user == null ? LoginPage() : HomePage(widget.user);
  }
}
