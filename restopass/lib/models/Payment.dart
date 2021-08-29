import 'dart:convert';

Payment paymentFromJson(String str) => Payment.fromJson(json.decode(str));
List<Payment> payementsFromJson(String str) =>
    List<Payment>.from(json.decode(str).map((x) => Payment.fromJson(x)));

class Payment {
  late int amount;
  late String resto;
  late String date;
  late String tarif;

  Payment(
      {required this.amount,
      required this.resto,
      required this.date,
      required this.tarif});

  static Payment fromJson(Map<String, dynamic> json) => Payment(
      amount: json['amount'],
      resto: json['resto'],
      date: json['date'],
      tarif: json['tarif']);
}
