import 'package:flutter/material.dart';
import 'package:restovigil/controllers/Request.dart';
import 'package:restovigil/models/Tarif.dart';
import 'package:restovigil/models/User.dart';
import 'package:restovigil/utils/Utils.dart';
import 'package:restovigil/views/Scanner.dart';

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
                  //logOut(context);
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
              Container(
                  child: FutureBuilder(
                future: _tarifsFuture,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Tarif>?> snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      color: Colors.white,
                      child: Center(child: Text("LOAD...")),
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
              ))
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
                    "assets/images/dinner.jpg", data[0].code),
              ),
            ],
          ),
          Container(
            width: size.width * .45,
            height: 200,
            margin: EdgeInsets.only(left: 15.0),
            padding: EdgeInsets.only(top: 7, left: 10, right: 10, bottom: 7),
            child: _cardItem(context, data[2].name, data[2].price,
                "assets/images/dinner.png", data[0].code),
          ),
        ],
      ),
    );
  }

  _errorWidget(BuildContext context) {
    return Container(
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
        ));
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
}
