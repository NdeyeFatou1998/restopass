import 'dart:convert';

Compte compteFromJson(String str) => Compte.fromJson(json.decode(str));

class Compte {
  late int id;
  late String accountNum;
  late String accountCode;
  late int pay;
  late int debt;
  late int status;
  late String? pin;
  late int userId;

  Compte(
      {required this.id,
      required this.accountCode,
      required this.accountNum,
      required this.pay,
      required this.debt,
      required this.status,
      this.pin,
      required this.userId});

  static Compte fromJson(Map<String, dynamic> json) => Compte(
        id: json['id'],
        accountNum: json['account_num'],
        accountCode: json['account_code'],
        pay: json['pay'],
        debt: json['debt'],
        status: json['status'],
        pin: json['pin'],
        userId: json['user_id'],
      );

  @override
  String toString() {
    return "COMPTE: id:$id,NUM: $accountNum, CODE: $accountCode, PAY: $pay, DEBT: $debt";
  }
}
