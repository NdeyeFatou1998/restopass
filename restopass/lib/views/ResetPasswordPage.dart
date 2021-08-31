import 'package:flutter/material.dart';
import 'package:restopass/controllers/Request.dart';
import 'package:restopass/models/Response.dart';
import 'package:restopass/utils/Utils.dart';
import 'package:restopass/utils/Widget.dart';
import 'package:http/http.dart' as http;
import 'package:restopass/views/NewPasswordPage.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool _hasErrors = false, _isLoad = false;
  String? _email;
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
                height: height * .30,
                child: Image.asset(
                  "assets/images/forgot_password.jpg",
                  fit: BoxFit.cover,
                )),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 30, bottom: 10),
              child: Text(
                "Mot de passe\nOublié",
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Poppins Meduim",
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
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
                  child: _emailField(),
                )),
            SizedBox(height: 20),
            _isLoad
                ? spinner(PRIMARY_COLOR, 30)
                : submitButton("Valider", onPressed: () async {
                    if (emailValidator(_email)) {
                      setState(() => _isLoad = true);
                      http.Response response =
                          await Request.resetPassword(_email!);
                      switch (response.statusCode) {
                        case 200:
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NewPasswordPage(_email!)));
                          break;
                        case 422:
                          toast(context, Colors.red,
                              "Cette adresse email n'existe pas.",
                              time: 5);
                          break;
                        case 500:
                          setState(() {
                            _hasErrors = true;
                            _message = responseFromJson(response.body).message;
                          });
                          break;
                      }
                    } else {
                      toast(context, Colors.red,
                          "Donner une adresse email valide.");
                    }
                    setState(() => _isLoad = false);
                  }),
          ],
        )),
      ),
    );
  }

  Widget _emailField() {
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
              _email = value;
            },
          ),
        ),
      ],
    );
  }
}
