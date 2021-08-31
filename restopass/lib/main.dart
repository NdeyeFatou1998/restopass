import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restopass/utils/Utils.dart';
import 'package:restopass/views/HomePage.dart';
import 'package:restopass/views/LoginPage.dart';
import 'package:restopass/views/SplashScreenPage.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('fr_FR', null).then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  var _routes = <String, Widget Function(BuildContext)>{
    '/': (context) => SplashScreenPage(),
    '/login': (context) => LoginPage(),
  };

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    return MaterialApp(
      routes: _routes,
      title: APP_NAME,
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(backgroundColor: Colors.white, primaryColor: PRIMARY_COLOR),
    );
  }
}
