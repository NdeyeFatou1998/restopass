import 'package:flutter/material.dart';
import 'package:restopass/models/Compte.dart';
import 'package:restopass/models/User.dart';
import 'package:restopass/utils/Utils.dart';
import 'package:restopass/views/SetPasswordPage.dart';
import 'package:restopass/views/SetPinPage1.dart';

class SettingsPage extends StatefulWidget {
  User user;
  Compte compte;
  SettingsPage(this.user, this.compte, {Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final String serviceNumber = "+221771234567";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(children: [
        Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            alignment: Alignment.topLeft,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    onPressed: () => {},
                    child: Row(
                      children: [
                        Icon(Icons.support_agent_rounded),
                        SizedBox(width: 15),
                        Text(
                          'Appelez le service client',
                          style: TextStyle(
                              fontFamily: 'Poppins Light',
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SetPasswordPage()));
                    },
                    child: Row(
                      children: [
                        Icon(Icons.password),
                        SizedBox(width: 15),
                        Text(
                          'Modifier votre mot de passe',
                          style: TextStyle(
                              fontFamily: 'Poppins Light',
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    onPressed: () async {
                      bool? b = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SetPinPage1()));
                      if (b != null && b) {
                        toast(context, Colors.green,
                            "Code pin modifier avec succès.");
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.security_rounded),
                        SizedBox(width: 15),
                        Text(
                          'Modifier votre code pin',
                          style: TextStyle(
                              fontFamily: 'Poppins Light',
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    onPressed: () async {},
                    child: Row(
                      children: [
                        Icon(Icons.photo_camera),
                        SizedBox(width: 15),
                        Text(
                          'Modier votre photo de profile',
                          style: TextStyle(
                              fontFamily: 'Poppins Light',
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ])),
      ]),
    );
  }
}
