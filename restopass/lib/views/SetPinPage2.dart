import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:restopass/controllers/Request.dart';
import 'package:restopass/models/Response.dart';
import 'package:restopass/utils/SharedPref.dart';
import 'package:restopass/utils/Utils.dart';
import 'package:restopass/utils/Widget.dart';

class SetPinPage2 extends StatefulWidget {
  late String pin;
  SetPinPage2(this.pin, {Key? key}) : super(key: key);

  @override
  _SetPinPage2State createState() => _SetPinPage2State();
}

class _SetPinPage2State extends State<SetPinPage2> {
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
              child: Text("Donner un nouveau code pin",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: "Poppins Light",
                      fontWeight: FontWeight.bold)),
            ),
            _pinPart(context),
            SizedBox(height: 20),
            _isLoad ? spinner(PRIMARY_COLOR, 50) : Container(),
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
          log(v, name: "NEW PIN");
          setState(() => _isLoad = true);
          Response? response = await Request.setPin(widget.pin, v);
          setState(() => _isLoad = true);
          if (response == null) {
            toast(context, Colors.red, "Vérifier votre connexion.");
          } else if (response.code == 200) {
            await SharedPref.setPin(v);
            Navigator.pop(context, true);
          } else {
            Navigator.pop(context, false);
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
