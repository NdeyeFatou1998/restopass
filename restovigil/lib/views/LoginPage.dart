import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restovigil/controllers/QrCodeScannerPage.dart';
import 'package:restovigil/controllers/Request.dart';
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

  @override
  void initState() {
    isLogin(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: isLogin(context),
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        print(snapshot.connectionState);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.hasData) {
            return Text(snapshot.data);
          } else {
            return const Text('Empty data');
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

  void _login(BuildContext context) async {
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
          break;
        case 404:
          break;
        case 400:
          break;
      }

      setState(() {
        _isLoad = false;
      });
    }
  }

  void saveInfo(BuildContext context, LoginResponse body) async {
    print(body.user);
    await SharedPref.saveUser(body.user);
    await SharedPref.saveResto(
        new Resto(name: body.user.resto ?? '', id: body.user.restoId ?? -1));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
