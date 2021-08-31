import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:restopass/controllers/Request.dart';
import 'package:restopass/models/LoginResponse.dart';
import 'package:restopass/utils/SharedPref.dart';
import 'package:restopass/utils/Utils.dart';
import 'package:restopass/utils/Widget.dart';
import 'package:http/http.dart' as http;

class NewPasswordPage extends StatefulWidget {
  late String email;
  NewPasswordPage(this.email, {Key? key}) : super(key: key);

  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool _hasErrors = false, _isLoad = false;
  String? _code;
  String? _password;
  String _message = "Votre adresse email est incorrecte.";

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

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
        title: Text("Mot de passe oublié",
            style: TextStyle(
                color: PRIMARY_COLOR,
                fontSize: 15,
                fontFamily: "Poppins Light",
                fontWeight: FontWeight.bold)),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 30, bottom: 10, top: 40),
              child: Text(
                "Nouveau\nMot de Passe",
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Poppins Meduim",
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Container(
                margin:
                    EdgeInsets.only(left: 26, right: 26, bottom: 10, top: 10),
                child: Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.red),
                        SizedBox(width: 5),
                        Expanded(
                            child: Text(
                                "Le code de validation vous a été envoyé par mail.",
                                textAlign: TextAlign.center)),
                      ],
                    ),
                  ),
                )),
            Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 30, top: 10),
                child: _hasErrors
                    ? Text(
                        _message,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red,
                          fontFamily: "Poppins Meduim",
                        ),
                        textAlign: TextAlign.left,
                      )
                    : null),
            Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _codeField(),
                      SizedBox(
                        height: 20,
                      ),
                      _passwordField()
                    ],
                  ),
                )),
            SizedBox(height: 20),
            _isLoad
                ? spinner(PRIMARY_COLOR, 30)
                : submitButton("Valider", onPressed: () async {
                    if (!codeValidator(_code)) {
                      toast(context, Colors.red,
                          "Donner un code de 6 caractères.");
                    } else if (!passwordValidator(_password)) {
                      toast(context, Colors.red,
                          "Mot de passe, 6 caractères min.");
                    } else {
                      String code = parseCode(_code!);
                      print("CODE : $code,PASSWORD: $_password, EMAIL: " +
                          widget.email);
                      setState(() => _isLoad = true);
                      http.Response response = await Request.newPassword(
                          widget.email, code, _password!);
                      log(response.body);
                      switch (response.statusCode) {
                        case 200:
                          afterAuth(response, context);
                          break;
                        case 422:
                          toast(context, Colors.red, "Le code est incorrecte");
                          break;
                        case 404:
                          toast(context, Colors.red, "Le code est incorrecte");
                          break;
                      }
                    }
                    setState(() => _isLoad = false);
                  }),
          ],
        )),
      ),
    );
  }

  Widget _codeField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Code de validation",
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
            inputFormatters: [
              MaskTextInputFormatter(
                  mask: '##-##-##', filter: {"#": RegExp(r'[0-9A-Za-z]')})
            ],
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(Icons.pin, color: PRIMARY_COLOR),
              hintText: "Code de Validation",
              hintStyle: TextStyle(color: Colors.black87),
            ),
            onChanged: (value) {
              _code = value;
            },
          ),
        ),
      ],
    );
  }

  Widget _passwordField() {
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
              _password = value;
            },
          ),
        ),
      ],
    );
  }
}
