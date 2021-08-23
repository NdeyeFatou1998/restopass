import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScannerPage extends StatefulWidget {
  const QrCodeScannerPage({Key? key}) : super(key: key);

  @override
  _QrCodeScannerPageState createState() => _QrCodeScannerPageState();
}

class _QrCodeScannerPageState extends State<QrCodeScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void dispose() {
    this.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [buildQrCode(context), buildOptions(context)],
    );
  }

  Widget buildQrCode(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderWidth: 10,
            borderLength: 20,
            borderRadius: 10,
            borderColor: Colors.blue,
            cutOutSize: MediaQuery.of(context).size.width * .8),
      );

  void _onQRViewCreated(QRViewController controller) async {
    this.barcode = await controller.scannedDataStream.elementAt(0);
    Navigator.of(context).pop(this.barcode?.code);
  }

  buildOptions(BuildContext context) {
    return Positioned(
        bottom: 20,
        child: Container(
          alignment: Alignment.center,
          height: 80,
          width: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    child: Icon(Icons.flash_on_rounded, size: 30),
                    onTap: () {
                      setState(() => {this.controller?.flipCamera()});
                    },
                  ),
                ),
              ),
              SizedBox(width: 20),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(Icons.cancel_rounded, size: 30),
                ),
              ),
            ],
          ),
        ));
  }
}
