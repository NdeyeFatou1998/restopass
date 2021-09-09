import 'dart:convert';

PayTech paytechFromJson(String str) => PayTech.fromJson(json.decode(str));

class PayTech {
  late int success;
  late String token;
  late String redirectUrl;

  PayTech(
      {required this.success, required this.token, required this.redirectUrl});

  static PayTech fromJson(Map<String, dynamic> json) => PayTech(
        success: json['success'],
        token: json['token'],
        redirectUrl: json['redirect_url'],
      );

  @override
  String toString() {
    return "PAY TECH success: $success, token: $token, URL: $redirectUrl";
  }
}
