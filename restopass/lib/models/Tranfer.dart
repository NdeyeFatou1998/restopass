import 'dart:convert';

Transfert transferFromJson(String str) => Transfert.fromJson(json.decode(str));

List<Transfert> tranfertsFromJson(String str) =>
    List<Transfert>.from(json.decode(str).map((x) => Transfert.fromJson(x)));

class Transfert {
  Transfert(
      {required this.amount,
      required this.date,
      required this.firstName,
      required this.lastName});

  String firstName;
  String lastName;
  String date;
  int amount;

  factory Transfert.fromJson(Map<String, dynamic> json) => Transfert(
        amount: json["amount"],
        date: json["date"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  @override
  String toString() {
    return "AMOUNT : " +
        amount.toString() +
        "\n" +
        "DATE : " +
        date +
        "\n" +
        "TO : " +
        firstName +
        " $lastName \n";
  }
}
