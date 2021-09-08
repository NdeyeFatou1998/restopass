import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restopass/models/PayTechResponse.dart';
import 'package:restopass/utils/Utils.dart';
import 'package:restopass/utils/Widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayTechPage extends StatefulWidget {
  PayTech pay;
  PayTechPage(this.pay, {Key? key}) : super(key: key);

  @override
  _PayTechPageState createState() => _PayTechPageState();
}

class _PayTechPageState extends State<PayTechPage> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    bool _inProgress = true;
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
          title: Text("Recharger mon compte",
              style: TextStyle(
                  color: PRIMARY_COLOR,
                  fontSize: 15,
                  fontFamily: "Poppins Light",
                  fontWeight: FontWeight.bold)),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: WebView(
              initialUrl: widget.pay.redirectUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onProgress: (int prc) async {
                log(prc.toString() + "%");
                if (prc >= 99) {
                  setState(() => _inProgress = false);
                }
              },
            ),
          ),
        ));
  }
}
