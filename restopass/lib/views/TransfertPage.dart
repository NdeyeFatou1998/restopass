import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:restopass/controllers/Request.dart';
import 'package:restopass/models/Compte.dart';
import 'package:restopass/models/Response.dart';
import 'package:restopass/models/Tranfer.dart';
import 'package:restopass/utils/Utils.dart';
import 'package:restopass/utils/Widget.dart';
import 'package:restopass/utils/card_item.dart';

class TransfertPage extends StatefulWidget {
  Compte compte;
  TransfertPage(this.compte, {Key? key}) : super(key: key);

  @override
  _TransfertPageState createState() => _TransfertPageState();
}

class _TransfertPageState extends State<TransfertPage> {
  String? _to;

  late Future<List<Transfert>?> _futureTransfert;

  @override
  void initState() {
    _futureTransfert = Request.getTranferts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: topPart(context),
        ),
        centerPart(context)
      ],
    );
  }

  Widget topPart(BuildContext context) {
    return Row(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 50,
          width: MediaQuery.of(context).size.width - 120,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black87),
            cursorColor: PRIMARY_COLOR,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(Icons.send_rounded, color: PRIMARY_COLOR),
              hintText: "Envoyer à",
              hintStyle: TextStyle(color: Colors.black87),
            ),
            onChanged: (value) {
              _to = value;
            },
            validator: (String? value) {},
          ),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            print("SCANNER LE QR CODE");
          },
          child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2))
                  ]),
              child: Icon(Icons.qr_code_scanner, color: PRIMARY_COLOR)),
        ),
      ],
    );
  }

  Widget centerPart(BuildContext context) {
    return FutureBuilder(
        future: _futureTransfert,
        builder: (context, AsyncSnapshot<List<Transfert>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              margin: EdgeInsets.only(top: 30),
              child: spinner(PRIMARY_COLOR, 50),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return _errorWidget(context);
            } else if (snapshot.hasData) {
              log("::::::::::::::::::::::::::::::::::::::::::::::::");
              return Expanded(
                  child: _afficherListTransfert(context, snapshot.data));
            } else {
              return logOut(context);
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        });
  }

  Widget _afficherListTransfert(context, List<Transfert>? list) {
    return list == null
        ? Center(
            child: Text("Aucune transactions effectuer."),
          )
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return CardItem(list[index]);
            });
  }

  Widget _errorWidget(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(left: 30, right: 30, bottom: 50, top: 30),
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
                  color: Colors.grey.withOpacity(0.2),
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
                    "Merci de vérifier votre connexion.",
                  ),
                ),
              ],
            )),
        ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(8.0),
              backgroundColor: MaterialStateProperty.all(PRIMARY_COLOR),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
            onPressed: () {
              setState(() {
                _futureTransfert = Request.getTranferts();
              });
            },
            child: Text("Ressayer"))
      ],
    );
  }
}
