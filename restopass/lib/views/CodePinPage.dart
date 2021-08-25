import 'package:flutter/material.dart';
import 'package:restopass/models/User.dart';

class CodePinPage extends StatefulWidget {
  late User user;
  CodePinPage(this.user, {Key? key}) : super(key: key);

  @override
  _CodePinPageState createState() => _CodePinPageState();
}

class _CodePinPageState extends State<CodePinPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Text("CODE PIN PAGE : " + widget.user.email)));
  }
}
