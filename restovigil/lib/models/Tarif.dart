import 'dart:convert';

Tarif tarifFromJson(String str) => Tarif.fromJson(json.decode(str));

List<Tarif> tarifsFromJson(String str) =>
    List<Tarif>.from(json.decode(str).map((x) => Tarif.fromJson(x)));

class Tarif {
  late int id;
  late String name;
  late int price;
  late int code;

  Tarif(
      {required this.id,
      required this.name,
      required this.price,
      required this.code});

  static fromJson(Map<String, dynamic> json) => Tarif(
      code: json['code'],
      id: json['id'],
      name: json['name'],
      price: json['price']);
}
