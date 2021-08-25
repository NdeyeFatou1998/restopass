import 'package:flutter/material.dart';
import 'package:restopass/models/User.dart';

class HomePage extends StatefulWidget {
  late User? user;
  HomePage(this.user, {Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("HOME : " + widget.user!.email)));
  }
}
