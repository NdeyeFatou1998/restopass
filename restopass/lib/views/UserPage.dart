import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:restopass/models/Compte.dart';
import 'package:restopass/models/User.dart';
import 'package:restopass/utils/Utils.dart';

class UserPage extends StatefulWidget {
  User user;
  Compte compte;
  UserPage(this.user, this.compte, {Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return _userPage(context, widget.user, widget.compte);
  }
}

Widget _userPage(BuildContext context, User user, Compte compte) {
  return SingleChildScrollView(
    child: Column(
      children: [
        Stack(
          children: [
            Container(height: 200),
            Container(
                alignment: Alignment.topCenter,
                height: 150,
                padding: EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  color: PRIMARY_COLOR_F1,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(.5),
                        offset: Offset(0, 2),
                        blurRadius: 5),
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      margin: EdgeInsets.only(left: 30, right: 20),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60)),
                      child: Image.asset("assets/images/dinner.png", width: 50),
                    ),
                    Text(user.firstName + " " + user.lastName,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins Light",
                            fontSize: 20,
                            fontWeight: FontWeight.w500))
                  ],
                )),
            Positioned(
              top: 110,
              left: 30,
              right: 30,
              height: 80,
              child: Material(
                elevation: 8.0,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                        MoneyFormatter(
                                amount: double.parse(compte.pay.toString()),
                                settings: MoneyFormatterSettings(
                                    symbol: 'F',
                                    thousandSeparator: '.',
                                    symbolAndNumberSeparator: ' ',
                                    fractionDigits: 0,
                                    compactFormatType: CompactFormatType.short))
                            .output
                            .symbolOnRight,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Poppins Bold",
                            fontWeight: FontWeight.w500,
                            fontSize: 25)),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Text(
                    'Carte Resto Pass',
                    style: TextStyle(fontFamily: 'Poppins Bold', fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 10,
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width * 0.6,
                      alignment: Alignment.center,
                      child: PrettyQr(
                        data: compte.accountCode,
                        typeNumber: 3,
                        image: AssetImage("assets/images/app_icon_black.png"),
                        roundEdges: true,
                        size: 200,
                      )),
                ),
                Container(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    'Votre QR code est privé. Si vous le partagez avec quelqu\'un, il peut l\'utiliser pour accéder au resto.',
                    style: TextStyle(fontFamily: 'Poppins Light', fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )),
      ],
    ),
  );
}
