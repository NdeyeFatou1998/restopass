import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:restopass/controllers/Request.dart';
import 'package:restopass/models/PayTechResponse.dart';
import 'package:restopass/utils/CurrencyInputFormatter.dart';
import 'package:restopass/utils/Utils.dart';
import 'package:restopass/utils/Widget.dart';
import 'package:restopass/views/PayTechPage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RechargementPage extends StatefulWidget {
  RechargementPage({Key? key}) : super(key: key);

  @override
  _RechargementPageState createState() => _RechargementPageState();
}

class _RechargementPageState extends State<RechargementPage> {
  bool _isLoad = false;
  int? _amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              height: MediaQuery.of(context).size.height * .30,
              child: Image.asset(
                "assets/images/achat.jpg",
                fit: BoxFit.cover,
              )),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 30, bottom: 10),
            child: Text(
              "Recharger\nMon compte",
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
                child: _amountField(),
              )),
          SizedBox(height: 20),
          _isLoad
              ? spinner(PRIMARY_COLOR, 30)
              : submitButton("Valider", onPressed: () async {
                  if (_amount != null && _amount! >= 50) {
                    setState(() {
                      _isLoad = true;
                    });
                    PayTech? response = await Request.payement(_amount!);
                    if (response == null) {
                      toast(context, Colors.red,
                          "Merci de vérifier votre connexion.",
                          time: 5);
                    } else {
                      log(response.toString());
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PayTechPage(response)));
                    }
                  } else {
                    toast(context, Colors.red, 'Montant minimum est 50 FCFA');
                  }
                  setState(() {
                    _isLoad = false;
                  });
                }),
        ],
      )),
    );
  }

  Widget _amountField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Montant (FCFA)",
            style: TextStyle(
                fontSize: 15,
                fontFamily: "Poppins Light",
                color: Colors.black)),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2))
                  ]),
              height: 50,
              width: MediaQuery.of(context).size.width - 110,
              padding: EdgeInsets.only(right: 10),
              child: TextFormField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black87),
                cursorColor: PRIMARY_COLOR,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon:
                      Icon(Icons.attach_money_outlined, color: PRIMARY_COLOR),
                  hintText: "Montant",
                  hintStyle: TextStyle(color: Colors.black87),
                ),
                onChanged: (value) {
                  _amount = int.tryParse(value);
                },
              ),
            ),
            Container(
                alignment: Alignment.center,
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2))
                    ]),
                child: Text(
                  'FCFA',
                  style: TextStyle(color: PRIMARY_COLOR),
                  textAlign: TextAlign.center,
                )),
          ],
        ),
      ],
    );
  }
}
