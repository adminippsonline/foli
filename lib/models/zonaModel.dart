
import 'dart:convert';

import '../data/login.dart';

Zonas zonasFromJson(String str) => Zonas.fromJson(json.decode(str));

String zonasToJson(Zonas data) => json.encode(data.toJson());

class Zonas {
  String? idZona;
  String? nombreDeLaZona;

  Zonas({
    this.idZona,
    this.nombreDeLaZona,
  });

  factory Zonas.fromJson(Map<String, dynamic> json) => Zonas(
    idZona: json["id_zona"],
    nombreDeLaZona: json["NombreDeLaZona"],
  );

  Map<String, dynamic> toJson() => {
    "id_zona": idZona,
    "NombreDeLaZona": nombreDeLaZona,
  };

  static List<Zonas> zones = [];
  getZonas(String admin, String crm)async{
    List<Zonas> temp = [];
    try{
      dynamic json = await LoginDataRequest().getZonas(admin, crm);
      for (var i = 0; i < json["data"].length; i++) {
        temp.add(Zonas.fromJson(json["data"][i]));
      }
      zones = temp;
    }catch(_){}
  }
}
