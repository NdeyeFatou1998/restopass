import 'dart:convert';

Transfert transferFromJson(String str) => Transfert.fromJson(json.decode(str));

List<Transfert> tranfertsFromJson(String str) =>
    List<Transfert>.from(json.decode(str).map((x) => Transfert.fromJson(x)));

class Transfert {
  Transfert(
      {required this.amount,
      required this.date,
      required this.toFirstName,
      required this.toLastName,
      required this.fromFirstName,
      required this.fromLastName,
      required this.toOrFrom});

  String toFirstName;
  String toLastName;
  String fromFirstName;
  String fromLastName;
  String date;
  int amount;
  int toOrFrom;

  factory Transfert.fromJson(Map<String, dynamic> json) => Transfert(
        amount: json["amount"],
        date: json["date"],
        toFirstName: json["to_first_name"],
        toLastName: json["to_last_name"],
        fromFirstName: json["from_first_name"],
        fromLastName: json["from_last_name"],
        toOrFrom: json["to_from"],
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
        toFirstName +
        " $toLastName , TO OR FROM: $toOrFrom\n";
  }
}
