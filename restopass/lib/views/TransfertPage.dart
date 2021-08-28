import 'dart:developer';

import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_input_formatter/mask_input_formatter.dart';
import 'package:restopass/controllers/Request.dart';
import 'package:restopass/models/Compte.dart';
import 'package:restopass/models/Response.dart';
import 'package:restopass/models/Tranfer.dart';
import 'package:restopass/utils/SharedPref.dart';
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
  final CurrencyTextFieldController _controller = CurrencyTextFieldController();

  late String _to;
  int? _amount;

  Color _desColor = PRIMARY_COLOR;
  Color _amountColor = PRIMARY_COLOR;

  late Future<List<Transfert>?> _futureTransfert;

  @override
  void initState() {
    _futureTransfert = Request.getTranferts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("TRANSFERT PAGE: " + widget.compte.toString());
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: topPart(context),
        ),
        centerPart(context)
      ],
    );
  }

  Widget topPart(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              width: MediaQuery.of(context).size.width - 130,
              padding: EdgeInsets.only(right: 10),
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MaskInputFormatter(mask: '###########', textAllCaps: true)
                ],
                style: TextStyle(color: Colors.black87),
                cursorColor: PRIMARY_COLOR,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(Icons.person, color: _desColor),
                  hintText: "Envoyer à",
                  hintStyle: TextStyle(color: Colors.black87),
                ),
                onChanged: (value) {
                  _to = value;
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                print("SCANNER LE QR CODE 0000");
              },
              child: Container(
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
                  child: Icon(Icons.qr_code_scanner, color: PRIMARY_COLOR)),
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () async {
                setState(() {
                  _amountColor = PRIMARY_COLOR;
                  _desColor = PRIMARY_COLOR;
                });
                // ignore: unnecessary_null_comparison
                if (_amount == null && _to == null) {
                  toast(context, Colors.red,
                      "Destinataire et montant sont requis.");
                  setState(() {
                    _amountColor = Colors.red;
                    _desColor = Colors.red;
                  });
                } else if (_amount == null) {
                  toast(context, Colors.red, "Veuillez saissir un montant.");
                  setState(() => _amountColor = Colors.red);
                  // ignore: unnecessary_null_comparison
                } else if (_to == null) {
                  toast(
                      context, Colors.red, "Veuillez saissir un destinataire.");
                  setState(() => _desColor = Colors.red);
                } else if (_to.length != 11) {
                  toast(context, Colors.red, "Déstinataire invalide.");
                  setState(() => _desColor = Colors.red);
                } else if (_amount! < 50) {
                  toast(context, Colors.red, "Montant minumum 50 F.");
                  setState(() => _amountColor = Colors.red);
                } else {
                  bool conf = await showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirmation'),
                          content:
                              Text('Transferer $_amount FCFA au numéro $_to?.'),
                          actions: [
                            TextButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(PRIMARY_COLOR),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: Text('Annuler'),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(PRIMARY_COLOR),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: Text('Oui'),
                            ),
                          ],
                        );
                      });

                  if (conf == true) {
                    print("FAIRE UN TRANSFERT de $_amount A $_to");
                    showLoaderDialog(context);
                    Response? result = await Request.transfert(_to, _amount);
                    Navigator.pop(context);

                    if (result == null) {
                    } else {
                      if (result.code == 200) {
                        widget.compte.pay -= _amount!;
                        setState(() {
                          _futureTransfert = Request.getTranferts();
                        });
                        toast(context, Colors.green, result.message, time: 5);
                      } else {
                        toast(context, Colors.red, result.message, time: 5);
                      }
                    }
                  } else {
                    toast(context, Colors.red, "Transfert annuler.");
                  }
                }
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
                  child: Icon(Icons.send_rounded, color: PRIMARY_COLOR)),
            ),
          ],
        ),
        SizedBox(height: 10),
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
              width: MediaQuery.of(context).size.width - 130,
              padding: EdgeInsets.only(right: 10),
              child: TextFormField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black87),
                cursorColor: PRIMARY_COLOR,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon:
                      Icon(Icons.attach_money_outlined, color: _amountColor),
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

  Widget centerPart(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: _futureTransfert,
          builder: (context, AsyncSnapshot<List<Transfert>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                margin: EdgeInsets.only(top: 30),
                child: spinner(PRIMARY_COLOR, 50),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              print(snapshot);
              if (snapshot.hasError) {
                return _errorWidget(context);
              } else if (snapshot.hasData) {
                return Expanded(
                    child: _afficherListTransfert(context, snapshot.data));
              } else {
                return logOut(context);
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          }),
    );
  }

  Widget _afficherListTransfert(context, List<Transfert>? list) {
    return list == null
        ? Center(
            child: Text("Aucune transactions effectuer."),
          )
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return CardItem(widget.compte.userId, list[index]);
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

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          spinner(PRIMARY_COLOR, 30),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text("Traitement en cours...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
