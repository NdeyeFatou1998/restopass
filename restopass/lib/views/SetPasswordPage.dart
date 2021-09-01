import 'package:flutter/material.dart';
import 'package:restopass/controllers/Request.dart';
import 'package:restopass/models/Response.dart';
import 'package:restopass/utils/Utils.dart';
import 'package:restopass/utils/Widget.dart';

class SetPasswordPage extends StatefulWidget {
  SetPasswordPage({Key? key}) : super(key: key);

  @override
  _SetPasswordPageState createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  bool _isLoad = false;
  String? _currentPassword;
  String? _newPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        iconTheme: IconThemeData(
          color: PRIMARY_COLOR,
        ),
        title: Text("Modifier mot de passe",
            style: TextStyle(
                color: PRIMARY_COLOR,
                fontSize: 15,
                fontFamily: "Poppins Light",
                fontWeight: FontWeight.bold)),
      ),
      body: Container(
        margin: EdgeInsets.only(
          top: 30,
        ),
        color: Colors.white,
        child: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 30, bottom: 10),
              child: Text(
                "Changer votre\nMot de Passe",
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Poppins Meduim",
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                child: Form(
                  child: Column(
                    children: [
                      _currentPasswordField(),
                      SizedBox(height: 30),
                      _newPasswordField(),
                    ],
                  ),
                )),
            SizedBox(height: 20),
            _isLoad == true
                ? spinner(PRIMARY_COLOR, 30)
                : submitButton("Valider", onPressed: () async {
                    setState(() => _isLoad = true);
                    if (passwordValidator(_newPassword) &&
                        passwordValidator(_currentPassword)) {
                      Response? response = await Request.setPassword(
                          _currentPassword!, _newPassword!);
                      if (response == null) {
                        logOut(context);
                      } else if (response.code == 200) {
                        toast(context, Colors.green, response.message,
                            time: 10);
                      } else if (response.code == 400) {
                        toast(context, Colors.red, response.message, time: 10);
                      }
                    } else {
                      toast(context, Colors.red, "Mot de passe < 6 caractères.",
                          time: 5);
                    }
                    setState(() => _isLoad = false);
                  }),
          ],
        )),
      ),
    );
  }

  Widget _currentPasswordField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Mot de passe actuel",
            style: TextStyle(
                fontSize: 15,
                fontFamily: "Poppins Light",
                color: Colors.black)),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextFormField(
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black87),
            cursorColor: PRIMARY_COLOR,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(Icons.password, color: PRIMARY_COLOR),
              hintText: "Mot de passe actuel",
              hintStyle: TextStyle(color: Colors.black87),
            ),
            onChanged: (value) {
              _currentPassword = value;
            },
          ),
        ),
      ],
    );
  }

  Widget _newPasswordField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Nouveau mot de passe",
            style: TextStyle(
                fontSize: 15,
                fontFamily: "Poppins Light",
                color: Colors.black)),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextFormField(
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black87),
            cursorColor: PRIMARY_COLOR,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(Icons.password, color: PRIMARY_COLOR),
              hintText: "Nouveau mot de passe",
              hintStyle: TextStyle(color: Colors.black87),
            ),
            onChanged: (value) {
              _newPassword = value;
            },
          ),
        ),
      ],
    );
  }
}
