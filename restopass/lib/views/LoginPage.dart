import 'package:flutter/material.dart';
import 'package:restopass/controllers/Request.dart';
import 'package:restopass/models/LoginData.dart';
import 'package:restopass/models/LoginResponse.dart';
import 'package:restopass/utils/SharedPref.dart';
import 'package:restopass/utils/Utils.dart';
import 'package:restopass/utils/Widget.dart';
import 'package:http/http.dart' as http;
import 'package:restopass/views/CodePinPage.dart';
import 'package:restopass/views/GivePinPage.dart';
import 'package:restopass/views/ResetPasswordPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoad = false;

  late bool isValide = false;

  late LoginData data;

  @override
  void initState() {
    data = new LoginData('', '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [topPart(context), centerPart(context)],
      ),
    ));
  }

  centerPart(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 20),
            child: Text(
              "Connectez vous!",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Poppins Light",
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: emailField(),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: passwordField(),
          ),
          SizedBox(height: 20),
          forgetPassword(onPressed: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ResetPasswordPage()));
          }),
          SizedBox(height: 10),
          _isLoad
              ? Container(
                  alignment: Alignment.center,
                  child: spinner(PRIMARY_COLOR, 30))
              : submitButton("Se connecter", onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isLoad = true;
                    });
                    http.Response? result = await Request.login(data);
                    if (result == null) {
                      toast(context, Colors.red,
                          "Impossible de se connecter au serveur.");
                    } else {
                      if (result.statusCode == 200) {
                        afterAuth(result, context);
                      } else if (result.statusCode == 422) {
                        print(result.body);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.red,
                            elevation: 8.0,
                            duration: Duration(seconds: 5),
                            content: Text('Email ou mot de passe incorrecte.'),
                            action: SnackBarAction(
                              label: 'Fermer',
                              textColor: Colors.white,
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              },
                            ),
                          ),
                        );
                      } else if (result.statusCode == 400) {
                        toast(context, Colors.red,
                            'Email et mot de passe requis.');
                      }
                    }
                    setState(() {
                      _isLoad = false;
                    });
                  } else {
                    toast(context, Colors.red,
                        "Veuillez vérifier vos informations.");
                  }
                })
        ],
      ),
    );
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
                Text("Bienvenue sur resto pass.",
                    style: TextStyle(
                        color: Colors.white, fontFamily: "Poppins Light"))
              ],
            )));
  }

  Widget emailField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Adresse Email",
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
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black87),
            cursorColor: PRIMARY_COLOR,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(Icons.email, color: PRIMARY_COLOR),
              hintText: "Adresse Email",
              hintStyle: TextStyle(color: Colors.black87),
            ),
            onChanged: (value) {
              data.email = value;
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Donner votre email';
              }
              if (!isMail(value)) {
                return 'Adresse email invalide.';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget passwordField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Mot de passe",
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
              obscureText: true,
              cursorColor: PRIMARY_COLOR,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.lock, color: PRIMARY_COLOR),
                hintText: "Mot de passe",
                hintStyle: TextStyle(color: Colors.black87),
              ),
              onChanged: (value) {
                data.password = value;
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Donner votre mot de passe';
                }
                return null;
              }),
        ),
      ],
    );
  }

  Widget forgetPassword({required void Function()? onPressed}) {
    return Container(
        padding: EdgeInsets.only(right: 30),
        alignment: Alignment.centerRight,
        child: TextButton(
            onPressed: onPressed,
            child: Text("Mot de passe oublié?",
                style: TextStyle(
                    color: PRIMARY_COLOR, fontFamily: "Poppins Light"))));
  }
}
