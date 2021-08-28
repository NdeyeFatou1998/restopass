import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:restopass/controllers/Request.dart';
import 'package:restopass/models/Compte.dart';
import 'package:restopass/models/User.dart';
import 'package:restopass/utils/SharedPref.dart';
import 'package:restopass/utils/Utils.dart';
import 'package:http/http.dart' as http;
import 'package:restopass/utils/Widget.dart';
import 'package:restopass/views/HomePage.dart';

class GivePinPage extends StatefulWidget {
  late User user;
  late Compte compte;
  GivePinPage(this.user, this.compte, {Key? key}) : super(key: key);

  @override
  _GivePinPageState createState() => _GivePinPageState();
}

class _GivePinPageState extends State<GivePinPage> {
  bool _isLoad = false;
  late String _pasteText;

  late bool _isDesableButton = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              topPart(context),
              SizedBox(height: 50),
              pinPart(context),
              SizedBox(height: 50),
              _isLoad == true
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        spinner(PRIMARY_COLOR, 50),
                        Text("Traitement en cours...",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins Light")),
                      ],
                    )
                  : Container(
                      child: TextButton(
                      onPressed: () async {},
                      child: Text("Code d'accès oublié?",
                          style: TextStyle(
                              color: PRIMARY_COLOR,
                              decoration: TextDecoration.underline)),
                    )),
            ],
          ),
        ));
  }

  topPart(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
                color: PRIMARY_COLOR,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(.5),
                      offset: Offset(0, 2),
                      blurRadius: 5),
                ],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(APP_NAME,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: "Poppins Bold",
                    )),
                Text("Saisisser votre code d'accès.",
                    style: TextStyle(
                        color: Colors.white, fontFamily: "Poppins Light"))
              ],
            )));
  }

  pinPart(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: PinCodeTextField(
        length: 4,
        obscureText: true,
        appContext: context,
        cursorColor: PRIMARY_COLOR,
        keyboardAppearance: Brightness.light,
        autovalidateMode: AutovalidateMode.always,
        backgroundColor: Colors.white,
        autoFocus: true,
        textStyle: TextStyle(color: PRIMARY_COLOR, fontFamily: "Poppins Light"),
        animationType: AnimationType.scale,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          activeFillColor: Colors.white,
          activeColor: PRIMARY_COLOR,
          selectedFillColor: Colors.grey.withOpacity(.2),
          inactiveFillColor: Colors.white,
          inactiveColor: PRIMARY_COLOR,
          selectedColor: PRIMARY_COLOR,
        ),
        animationDuration: Duration(milliseconds: 300),
        enableActiveFill: true,
        onCompleted: (v) async {
          print("Completed $v");
          setState(() => _isLoad = true);
          String? code = await SharedPref.getPin();
          print("CODE LOCAL: $code, IN: $v");
          if (code == null) {
            logOut(context);
          } else if (code == v) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                        widget.user, ValueNotifier<Compte>(widget.compte))));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.redAccent,
                elevation: 8.0,
                duration: Duration(seconds: 5),
                content: Text('Code d\'accès incorrect.'),
                action: SnackBarAction(
                  label: 'Fermer',
                  textColor: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );
          }
          setState(() => _isLoad = false);
        },
        onChanged: (value) {
          print(value);
        },
        beforeTextPaste: (text) {
          if (text != null) _pasteText = text.substring(0, 4);
          return true;
        },
        dialogConfig: DialogConfig(
            dialogTitle: 'Utiliser ce code?',
            dialogContent: 'Utiliser ce code ',
            affirmativeText: 'Oui',
            negativeText: 'Non'),
      ),
    );
  }
}
