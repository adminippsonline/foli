import 'dart:convert';

import '../data/login.dart';



class Pedidos {
  String? status;
  int? code;
  String? total;
  Map<String, Datum>? data;

  Pedidos({
    this.status,
    this.code,
    this.total,
    this.data,
  });

  factory Pedidos.fromJson(Map<String, dynamic> json) => Pedidos(
    status: json["status"],
    code: json["code"],
    total: json["total"],
    data: Map.from(json["data"]!).map((k, v) => MapEntry<String, Datum>(k, Datum.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "total": total,
    "data": Map.from(data!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };

  static Pedidos pedidos = Pedidos();
  Future getPedidos(String admin, String crm, String perfil)async{
    Pedidos pedidosTemp = Pedidos();
    try {
      dynamic json = await LoginDataRequest().getPedidos(admin, crm, perfil);
      if (json is! int) {
        pedidosTemp = Pedidos.fromJson(json);
      }
      pedidos= pedidosTemp;
    }catch(w){
      print(w);
    }
    return pedidos;
  }
}

class Datum {
  String? idLr;
  String? nombre;
  String? nombreDelNegocio;
  String? imagen;
  String? alias;
  String? lat;
  String? lon;
  String? totalAPagar;
  String? cantidad;
  String? direccion;
  String? idPWeb;
  String? idProgramado;

  Datum({
    this.idLr,
    this.nombre,
    this.nombreDelNegocio,
    this.imagen,
    this.alias,
    this.lat,
    this.lon,
    this.totalAPagar,
    this.cantidad,
    this.direccion,
    this.idProgramado,
    this.idPWeb,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    idLr: json["id_LR"],
    nombre: json["Nombre"],
    nombreDelNegocio: json["NombreDelNegocio"],
    imagen: json["Imagen"],
    alias: json["Alias"],
    lat: json["Lat"],
    lon: json["Lon"],
    totalAPagar: json["TotalAPagar"],
    cantidad: json["Cantidad"].toString(),
    direccion: json["Direccion"],
    idPWeb: json["id_PWeb"],
    idProgramado: json["id_programado"],
  );

  Map<String, dynamic> toJson() => {
    "id_LR": idLr,
    "Nombre": nombre,
    "NombreDelNegocio": nombreDelNegocio,
    "Imagen": imagen,
    "Alias": alias,
    "Lat": lat,
    "Lon": lon,
    "TotalAPagar": totalAPagar,
    "Cantidad": cantidad,
    "Direccion": direccion,
    "id_PWeb": idPWeb,
    "id_programado": idProgramado,
  };
}
