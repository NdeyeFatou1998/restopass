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

class CodePinPage extends StatefulWidget {
  late User user;
  late Compte compte;
  CodePinPage(this.user, this.compte, {Key? key}) : super(key: key);

  @override
  _CodePinPageState createState() => _CodePinPageState();
}

class _CodePinPageState extends State<CodePinPage> {
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
                  : Container(),
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
                Text("Ajouter un code pin pour plus de securité.",
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
        obscureText: false,
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
          setState(() {
            _isLoad = true;
          });
          http.Response? result = await Request.createPin(v);
          if (result == null)
            print("TOKEN NULL");
          else {
            switch (result.statusCode) {
              case 200:
                await SharedPref.setPin(v);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(widget.user,
                            ValueNotifier<Compte>(widget.compte))));
                break;
              case 500:
                print(result.body);
                break;
              case 422:
                print("RESPONSE CODE: " + result.body);
                break;
              case 401:
                logOut(context);
                break;
              default:
            }
          }
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
