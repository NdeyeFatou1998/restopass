import 'package:flutter/material.dart';
import 'package:restovigil/controllers/Request.dart';
import 'package:restovigil/models/Tarif.dart';
import 'package:restovigil/models/User.dart';
import 'package:restovigil/utils/Utils.dart';
import 'package:restovigil/views/ScannerPage.dart';

class HomePage extends StatefulWidget {
  User? user;
  HomePage(this.user, {Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Tarif>?> _tarifsFuture;

  @override
  void initState() {
    _tarifsFuture = Request.getTarifs(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: PRIMARY_COLOR,
          elevation: 8.0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return customDialog(context);
                      });
                },
              );
            },
          ),
          iconTheme: IconThemeData(
            color: PRIMARY_COLOR,
          ),
          title: Text("RestoPass",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: "Poppins Light",
                  fontWeight: FontWeight.bold)),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.all(20),
                  width: size.width,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        )
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                              child: Icon(Icons.account_box,
                                  color: Colors.red, size: 35)),
                          SizedBox(width: 10),
                          Text(widget.user!.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: "Poppins Light"),
                              textAlign: TextAlign.left),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(widget.user!.matricule,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: "Poppins Light"),
                          textAlign: TextAlign.center),
                    ],
                  )),
              FutureBuilder(
                future: _tarifsFuture,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Tarif>?> snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      margin: EdgeInsets.only(top: 30),
                      child:
                          progressBar("Chargement des tarifs en cours...", 50),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return _errorWidget(context);
                    } else if (snapshot.hasData) {
                      return _tarifContainer(context, snapshot.data);
                    } else {
                      return logOut(context);
                    }
                  } else {
                    return Text('State: ${snapshot.connectionState}');
                  }
                },
              )
            ],
          ),
        ));
  }

  Widget _tarifContainer(BuildContext context, List<Tarif>? data) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top: 15),
      margin: EdgeInsets.only(top: 10),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: size.width * .45,
                height: 200,
                margin: EdgeInsets.all(10),
                padding:
                    EdgeInsets.only(top: 7, left: 10, right: 10, bottom: 7),
                child: _cardItem(context, data![0].name, data[0].price,
                    "assets/images/breakfast.jpg", data[0].code),
              ),
              Container(
                width: size.width * .45,
                height: 200,
                padding:
                    EdgeInsets.only(top: 7, left: 10, right: 10, bottom: 7),
                child: _cardItem(context, data[1].name, data[1].price,
                    "assets/images/dinner.jpg", data[1].code),
              ),
            ],
          ),
          Container(
            width: size.width * .45,
            height: 200,
            margin: EdgeInsets.only(left: 15.0),
            padding: EdgeInsets.only(top: 7, left: 10, right: 10, bottom: 7),
            child: _cardItem(context, data[2].name, data[2].price,
                "assets/images/dinner.png", data[2].code),
          ),
        ],
      ),
    );
  }

  _errorWidget(BuildContext context) {
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
                _tarifsFuture = Request.getTarifs(context);
              });
            },
            child: Text("Ressayer"))
      ],
    );
  }

  Widget _cardItem(
      BuildContext context, String title, int price, String image, int id) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ScannerPage(
                    Tarif(code: id, id: id, name: title, price: price))));
      },
      child: Material(
        color: Colors.white,
        elevation: 5.0,
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100.0,
              width: 100.0,
              child: Image.asset(image),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              title,
              style: TextStyle(fontFamily: "Poppin Light", fontSize: 15.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              price.toString() + " FCFA",
              style: TextStyle(
                fontFamily: "Poppin Light",
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  customDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, top: 50, right: 20, bottom: 20),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.5),
                    offset: Offset(0, 5),
                    blurRadius: 5),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Voulez-vous vous deconnecter?",
                style: TextStyle(fontSize: 15, fontFamily: "Poppins Light"),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Annuler',
                        style: TextStyle(fontSize: 18),
                      )),
                  TextButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black)),
                      onPressed: () {
                        logOut(context);
                      },
                      child: Text(
                        'Oui',
                        style: TextStyle(fontSize: 18),
                      )),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
