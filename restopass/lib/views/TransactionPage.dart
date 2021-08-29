import 'package:flutter/material.dart';
import 'package:restopass/controllers/Request.dart';
import 'package:restopass/models/Payment.dart';
import 'package:restopass/models/User.dart';
import 'package:restopass/utils/PaymentCardItem.dart';
import 'package:restopass/utils/Utils.dart';
import 'package:restopass/utils/Widget.dart';

class TransactionPage extends StatefulWidget {
  final User user;
  const TransactionPage(this.user, {Key? key}) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: PRIMARY_COLOR,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(.5),
                    offset: Offset(0, 2),
                    blurRadius: 5),
              ],
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Text("Historique des passages au resto.",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center),
          )
        ]),
        SizedBox(height: 20),
        Container(
            child: FutureBuilder(
          future: Request.getPayments(),
          builder: (context, AsyncSnapshot<List<Payment>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  child: spinner(PRIMARY_COLOR, 50),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              print(snapshot);
              if (snapshot.hasError) {
                return _errorWidget(context);
              } else if (snapshot.hasData) {
                return Expanded(child: _listPayment(context, snapshot.data));
              } else {
                return logOut(context);
              }
            } else {
              return Center(
                child: Text(
                    'State: ${snapshot.connectionState}, ' +
                        'Merci de contacter le service client.',
                    style: TextStyle(color: Colors.black)),
              );
            }
          },
        )),
      ],
    );
  }

  Widget _errorWidget(BuildContext context) {
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
              setState(() {});
            },
            child: Text("Ressayer"))
      ],
    );
  }

  Widget _listPayment(BuildContext context, List<Payment>? list) {
    return list!.length == 0
        ? Center(
            child: Text("Aucune transactions effectuer."),
          )
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return PaymentCardItem(list[index]);
            });
  }
}
