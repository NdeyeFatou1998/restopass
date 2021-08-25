import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restovigil/controllers/QrCodeScannerPage.dart';
import 'package:restovigil/controllers/Request.dart';
import 'package:restovigil/models/LoginError.dart';
import 'package:restovigil/models/LoginResponse.dart';
import 'package:restovigil/models/Resto.dart';
import 'package:restovigil/models/Tarif.dart';
import 'package:restovigil/models/User.dart';
import 'package:restovigil/utils/SharedPref.dart';
import 'package:restovigil/utils/Utils.dart';
import 'package:http/http.dart' as http;
import 'package:restovigil/views/HomePage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoad = false;
  LoginError? errors;
  late Future<User?> _isLogin;
  @override
  void initState() {
    _isLogin = isLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: _isLogin,
      builder: (
        BuildContext context,
        AsyncSnapshot<User?> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _splashScreen();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.hasData) {
            return HomePage(snapshot.data);
          } else {
            return _mainWidget(context);
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      });

  _mainWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 250,
                  width: size.width,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: PRIMARY_COLOR,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        APP_NAME,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins Light"),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Utiliser votre carte pour vous connectez.",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: "Poppins Light"),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                )),
            SizedBox(
              height: 30,
            ),
            _isLoad == true
                ? progressBar("Traitement en cours...")
                : Container(),
            SizedBox(
              height: 30,
            ),
            errors == null ? Container() : _errorWidget(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.camera_alt, color: Colors.white),
          backgroundColor: PRIMARY_COLOR,
          label: Text("Se connecter", style: TextStyle(color: Colors.white)),
          onPressed: () {
            _login(context);
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _splashScreen() {
    return Scaffold(body: Center(child: progressBar("Resto Pass")));
  }

  void _login(BuildContext context) async {
    errors = null;
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const QrCodeScannerPage()),
    );
    if (result == null) {
      print("QR CODE NULL");
    } else {
      setState(() {
        _isLoad = true;
      });
      http.Response res = await Request.login(result);

      switch (res.statusCode) {
        case 200:
          saveInfo(context, loginResponseFromJson(res.body));
          break;
        case 422:
          setState(() {
            errors = new LoginError("Veuillez vérifier votra carte.", true);
          });
          break;
        case 400:
          setState(() {
            errors = new LoginError(
                "Vous n\'étes affecté à aucun resto pour le moment.", true);
          });
          break;
        case 500:
          setState(() {
            errors = new LoginError(
                "Merci de verifier votre connexion internet.", true);
          });
          break;
      }
      setState(() {
        _isLoad = false;
      });
    }
  }

  void saveInfo(BuildContext context, LoginResponse body) async {
    await SharedPref.saveUser(body.user);
    await SharedPref.saveToken(body.token);
    await SharedPref.saveResto(
        new Resto(name: body.user.resto ?? '', id: body.user.restoId ?? -1));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage(body.user)));
  }

  _errorWidget(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 30, right: 30, bottom: 50),
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline_outlined, color: Colors.red),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                errors?.message ?? '',
              ),
            ),
          ],
        ));
  }
}
