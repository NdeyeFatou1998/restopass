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
  @override
  Widget build(BuildContext context) {
    bool mode = widget.user != widget.transfer.toOrFrom;
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
                    mode ? Icons.call_made : Icons.call_received_sharp,
                    size: 20,
                    color: mode ? Colors.red : Colors.green,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.transfer.firstName +
                            " " +
                            widget.transfer.lastName,
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
                      color: mode ? Colors.red : Colors.green),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
