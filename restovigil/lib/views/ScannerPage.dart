import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:restovigil/controllers/QrCodeScannerPage.dart';
import 'package:restovigil/controllers/Request.dart';
import 'package:restovigil/models/ScannerResponse.dart';
import 'package:restovigil/models/Tarif.dart';
import 'package:restovigil/utils/Utils.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class ScannerPage extends StatefulWidget {
  Tarif tarif;
  ScannerPage(this.tarif, {Key? key}) : super(key: key);

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  late Widget _other;

  @override
  void initState() {
    _other = Text("Cliquez sur le button en bas pour commencer.");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
        elevation: 8.0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        iconTheme: IconThemeData(
          color: PRIMARY_COLOR,
        ),
        title: Text(
            widget.tarif.name + ' (' + widget.tarif.price.toString() + ' F)',
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: "Poppins Light",
                fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: _other),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.camera_alt, color: Colors.white),
          backgroundColor: PRIMARY_COLOR,
          label:
              Text("Scanner une carte.", style: TextStyle(color: Colors.white)),
          onPressed: () async {
            final result = await Navigator.push<String>(
              context,
              MaterialPageRoute(
                  builder: (context) => const QrCodeScannerPage()),
            );
            if (result != null) {
              setState(() {
                _other = progressBar("Traitement en cours...", 120);
              });
              ScannerResponse? res =
                  await Request.scan(context, result, widget.tarif.code);
              if (res == null) {
                setState(() {
                  _other =
                      onError(context, "Merci de vérifier votre connexion.");
                });
              } else {
                switch (res.code) {
                  case 200:
                    setState(() {
                      _other = onSuccess(context, res.message, Colors.green);
                    });
                    break;
                  case 400:
                    setState(() {
                      _other = onInfo(context, Colors.orange, res.message);
                    });
                    break;
                  case 404:
                    setState(() {
                      _other = onError(context, res.message);
                    });
                    break;
                }
              }
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
