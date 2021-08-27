import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:restopass/models/Compte.dart';
import 'package:restopass/models/User.dart';
import 'package:restopass/utils/Utils.dart';
import 'package:restopass/views/RechargementPage.dart';
import 'package:restopass/views/TransactionPage.dart';
import 'package:restopass/views/TransfertPage.dart';

import 'UserPage.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  late User user;
  late Compte compte;
  HomePage(this.user, this.compte, {Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  late Widget _currentPage;

  @override
  void initState() {
    _currentPage = UserPage(widget.user, widget.compte);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
        elevation: 5,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu_open_rounded),
              onPressed: () {},
            );
          },
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(APP_NAME,
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: "Poppins Light",
                fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        buttonBackgroundColor: PRIMARY_COLOR,
        color: PRIMARY_COLOR,
        items: <Widget>[
          Icon(Icons.person, color: Colors.white, size: 30),
          Icon(Icons.send_rounded, color: Colors.white, size: 30),
          Icon(Icons.list, color: Colors.white, size: 30),
          Icon(Icons.payment_rounded, color: Colors.white, size: 30),
        ],
        onTap: (index) {
          setState(() {
            switch (index) {
              case 0:
                _currentPage = UserPage(widget.user, widget.compte);
                break;
              case 1:
                _currentPage = TransfertPage(widget.compte);
                break;
              case 2:
                _currentPage = transactionPage(context);
                break;
              case 3:
                _currentPage = rechargementPage(context);
                break;
              default:
                print("ERRORRRRRRRRRR");
            }
            _index = index;
          });
        },
      ),
      body: _currentPage,
    );
  }
}
