import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:restovigil/controllers/QrCodeScannerPage.dart';
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
    _other = Expanded(
      child: Text("Cliquez sur le button en bas pour commencer."),
    );
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
            Positioned(bottom: 100, right: 0, child: _buttonScanner(context)),
          ],
        ));
  }

  Widget _buttonScanner(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push<String>(
          context,
          MaterialPageRoute(builder: (context) => const QrCodeScannerPage()),
        );
        if (result == null) {
          print("QR CODE NULL");
        } else {
          print("QR :::::::::::::::::::::::::::::::: $result");
          setState(() {
            _other = onSuccess(context, result, Colors.green);
          });
        }
      },
      child: Material(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(80), bottomLeft: Radius.circular(80)),
        elevation: 8.0,
        child: Container(
            width: 100,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: Icon(Icons.qr_code_2, size: 50, color: PRIMARY_COLOR)),
      ),
    );
  }
}
