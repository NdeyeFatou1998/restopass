import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restopass/models/Tranfer.dart';

class CardItem extends StatefulWidget {
  final Transfert transfer;
  final int user;

  CardItem(
    this.user,
    this.transfer, {
    Key? key,
  }) : super(key: key);

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  late String name;

  @override
  Widget build(BuildContext context) {
    bool isFromMe = widget.user != widget.transfer.toOrFrom;
    if (isFromMe == false) {
      name = widget.transfer.fromFirstName + " " + widget.transfer.fromLastName;
    } else {
      name = widget.transfer.toFirstName + " " + widget.transfer.toLastName;
    }
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isFromMe ? Icons.call_made : Icons.call_received_sharp,
                    size: 20,
                    color: isFromMe ? Colors.red : Colors.green,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: "Poppins Light",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        DateFormat.yMMMMd('fr_FR').format(
                            DateFormat("yyyy-MM-dd")
                                .parse(widget.transfer.date)),
                        style: TextStyle(
                          fontFamily: "Poppins Light",
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                child: Text(
                  widget.transfer.amount.toString() + " FCFA",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Poppins Light",
                      fontWeight: FontWeight.bold,
                      color: isFromMe ? Colors.red : Colors.green),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
