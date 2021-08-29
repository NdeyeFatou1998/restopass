import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restopass/models/Payment.dart';

class PaymentCardItem extends StatefulWidget {
  final Payment payment;

  PaymentCardItem(
    this.payment, {
    Key? key,
  }) : super(key: key);

  @override
  _PaymentCardItemState createState() => _PaymentCardItemState();
}

class _PaymentCardItemState extends State<PaymentCardItem> {
  @override
  Widget build(BuildContext context) {
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.payment.resto,
                        style: TextStyle(
                          fontFamily: "Poppins Light",
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        DateFormat.yMMMMd('fr_FR').format(
                            DateFormat("yyyy-MM-dd")
                                .parse(widget.payment.date)),
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
                  widget.payment.amount.toString() + " FCFA",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Poppins Light",
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
