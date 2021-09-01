import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:restopass/utils/SharedPref.dart';
import 'package:restopass/utils/Utils.dart';
import 'package:restopass/views/SetPinPage2.dart';

class SetPinPage1 extends StatefulWidget {
  SetPinPage1({Key? key}) : super(key: key);

  @override
  _SetPinPage1State createState() => _SetPinPage1State();
}

class _SetPinPage1State extends State<SetPinPage1> {
  bool _isLoad = false;

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
        title: Text("Modifier code pin",
            style: TextStyle(
                color: PRIMARY_COLOR,
                fontSize: 15,
                fontFamily: "Poppins Light",
                fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50, left: 20, right: 20),
              alignment: Alignment.center,
              child: Text("Donner votre code pin",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: "Poppins Light",
                      fontWeight: FontWeight.bold)),
            ),
            _pinPart(context),
          ],
        ),
      ),
    );
  }

  Widget _pinPart(BuildContext context) {
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
        keyboardType: TextInputType.number,
        inputFormatters: [
          MaskTextInputFormatter(mask: '####', filter: {"#": RegExp(r'[0-9]')})
        ],
        autovalidateMode: AutovalidateMode.always,
        backgroundColor: Colors.white,
        autoFocus: true,
        textStyle: TextStyle(color: PRIMARY_COLOR, fontFamily: "Poppins Light"),
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          activeFillColor: Colors.white,
          activeColor: PRIMARY_COLOR,
          selectedFillColor: PRIMARY_COLOR.withOpacity(.1),
          inactiveFillColor: Colors.white,
          inactiveColor: PRIMARY_COLOR,
          selectedColor: PRIMARY_COLOR,
        ),
        animationDuration: Duration(milliseconds: 300),
        enableActiveFill: true,
        onCompleted: (v) async {
          String? code = await SharedPref.getPin();
          log("LOCAL CODE $code, IN $v", name: "GIVE PIN CODE");
          if (code == null) {
            logOut(context);
          }
          if (v == code) {
            bool? b = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => SetPinPage2(code!)));
            if (b != null && b) {
              Navigator.pop(context, b);
            } else if (b != null && !b) {
              toast(context, Colors.red, "Code Pin incorrecte.", time: 5);
            }
          } else {
            toast(context, Colors.red, "Code Pin incorrecte.", time: 5);
          }
        },
        onChanged: (value) {
          print(value);
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
