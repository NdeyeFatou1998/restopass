import 'dart:convert';

Response responseFromJson(String str) => Response.fromJson(json.decode(str));

class Response {
  late String message;
  late int code;

  Response({required this.message, required this.code});

  static Response fromJson(Map<String, dynamic> json) =>
      Response(code: json['code'], message: json['message']);

  @override
  String toString() {
    return "REPONSE: message: $message, code: $code";
  }
}
