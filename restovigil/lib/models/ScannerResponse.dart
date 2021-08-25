import 'dart:convert';

ScannerResponse scannerResponseFromJson(String str) =>
    ScannerResponse.fromJson(json.decode(str));

class ScannerResponse {
  late String message;
  late int code;

  ScannerResponse({required this.message, required this.code});

  static fromJson(Map<String, dynamic> json) =>
      ScannerResponse(message: json['message'], code: json['code']);
}
