import 'package:flutter/material.dart';
import 'package:restopass/controllers/Request.dart';
import 'package:restopass/utils/Utils.dart';
import 'package:restopass/utils/Widget.dart';
import 'package:http/http.dart' as http;

class ResetPinPage extends StatefulWidget {
  ResetPinPage({Key? key}) : super(key: key);

  @override
  _ResetPinPageState createState() => _ResetPinPageState();
}

class _ResetPinPageState extends State<ResetPinPage> {
  bool _isLoad = false;
  String? _email;
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
        title: Text("Code Pin oublié",
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
                "Code Pin\nOublié",
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
                  child: _emailField(),
                )),
            SizedBox(height: 20),
            _isLoad
                ? spinner(PRIMARY_COLOR, 30)
                : submitButton("Valider", onPressed: () async {
                    FocusScope.of(context).unfocus();

                    if (emailValidator(_email)) {
                      setState(() => _isLoad = true);
                      http.Response response = await Request.resetPin(_email!);

                      switch (response.statusCode) {
                        case 200:
                          await messageDialog(context,
                              "Nous vous avons envoyé votre code pin par email.");
                          break;
                        case 422:
                          toast(context, Colors.red,
                              "Votre adresse email est incorrecte.");
                          break;
                        case 500:
                          toast(context, Colors.red,
                              "Une erreur s\'est produit. Merci de réessayer plus tard.");
                          break;
                        default:
                      }

                      setState(() => _isLoad = false);
                    } else {
                      toast(context, Colors.red,
                          "Donner une adresse email valide.");
                    }
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
