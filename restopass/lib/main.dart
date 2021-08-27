import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restopass/utils/Utils.dart';
import 'package:restopass/views/SplashScreenPage.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('fr_FR', null).then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: APP_NAME,
      home: SplashScreenPage(),
    );
  }
}
