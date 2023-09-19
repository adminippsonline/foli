// To parse this JSON data, do
//
//     final detalle = detalleFromJson(jsonString);

import 'dart:convert';

Detalle detalleFromJson(String str) => Detalle.fromJson(json.decode(str));

String detalleToJson(Detalle data) => json.encode(data.toJson());

class Detalle {
  String? status;
  String? code;
  String? idLr;
  String? idDominio;
  String? idPWeb;
  String? idProgramado;
  String? total;
  List<Datum>? data;
  List<Seleccionado>? seleccionados;

  Detalle({
    this.status,
    this.code,
    this.idLr,
    this.idDominio,
    this.idPWeb,
    this.idProgramado,
    this.total,
    this.data,
    this.seleccionados,
  });

  factory Detalle.fromJson(Map<String, dynamic> json) => Detalle(
    status: json["status"],
    code: json["code"],
    idLr: json["id_LR"],
    idDominio: json["id_dominio"],
    idPWeb: json["id_PWeb"],
    idProgramado: json["id_programado"],
    total: json["total"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    seleccionados: json["Seleccionados"] == null ? [] : List<Seleccionado>.from(json["Seleccionados"]!.map((x) => Seleccionado.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "id_LR": idLr,
    "id_dominio": idDominio,
    "id_PWeb": idPWeb,
    "id_programado": idProgramado,
    "total": total,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "Seleccionados": seleccionados == null ? [] : List<dynamic>.from(seleccionados!.map((x) => x.toJson())),
  };

  static Detalle detalle = Detalle();
}

class Datum {
  String? idProducto;
  String? nombreDelProducto;
  String? precio;
  String? precioApp;
  String? idDominio;

  Datum({
    this.idProducto,
    this.nombreDelProducto,
    this.precio,
    this.precioApp,
    this.idDominio,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    idProducto: json["id_producto"],
    nombreDelProducto: json["NombreDelProducto"],
    precio: json["Precio"],
    precioApp: json["PrecioAPP"],
    idDominio: json["id_dominio"],
  );

  Map<String, dynamic> toJson() => {
    "id_producto": idProducto,
    "NombreDelProducto": nombreDelProducto,
    "Precio": precio,
    "PrecioAPP": precioApp,
    "id_dominio": idDominio,
  };
}

class Seleccionado {
  String? nombreProducto;
  String? cantidad;
  String? precio;

  Seleccionado({
    this.nombreProducto,
    this.cantidad,
    this.precio,
  });

  factory Seleccionado.fromJson(Map<String, dynamic> json) => Seleccionado(
    nombreProducto: json["NombreProducto"],
    cantidad: json["Cantidad"],
    precio: json["Precio"],
  );

  Map<String, dynamic> toJson() => {
    "NombreProducto": nombreProducto,
    "Cantidad": cantidad,
    "Precio": precio,
  };
}
