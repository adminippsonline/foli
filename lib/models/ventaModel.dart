import 'dart:convert';

import 'package:ippsonline/data/login.dart';

Venta ventaFromJson(String str) => Venta.fromJson(json.decode(str));

String ventaToJson(Venta data) => json.encode(data.toJson());

class Venta {
  String? idEntrega;
  String? idPv;
  String? idPWeb;
  String? idProgramado;
  String? cantidad;
  String? total;
  String? nombre;
  String? nombreDelNegocio;
  String? alias;
  String? idLr;

  Venta({
    this.idEntrega,
    this.idPv,
    this.idPWeb,
    this.idProgramado,
    this.cantidad,
    this.total,
    this.nombre,
    this.nombreDelNegocio,
    this.alias,
    this.idLr,
  });

  factory Venta.fromJson(Map<String, dynamic> json) => Venta(
    idEntrega: json["id_entrega"],
    idPv: json["id_PV"],
    idPWeb: json["id_PWeb"],
    idProgramado: json["id_programado"],
    cantidad: json["Cantidad"],
    total: json["Total"],
    nombre: json["Nombre"],
    nombreDelNegocio: json["NombreDelNegocio"],
    alias: json["Alias"],
    idLr: json["id_LR"],
  );

  Map<String, dynamic> toJson() => {
    "id_entrega": idEntrega,
    "id_PV": idPv,
    "id_PWeb": idPWeb,
    "id_programado": idProgramado,
    "Cantidad": cantidad,
    "Total": total,
    "Nombre": nombre,
    "NombreDelNegocio": nombreDelNegocio,
    "Alias": alias,
    "id_LR": idLr,
  };
  static List<Venta> ventas = [];
  getVentas(String admin, String crm, String perfil)async{
    List<Venta> temp = [];
    try{
      dynamic json = await LoginDataRequest().getVentas(admin, crm, perfil);
      for (var i = 0; i < json["data"].length; i++) {
         temp.add(Venta.fromJson(json["data"][i]));
      }
      ventas = temp;
    }catch(_){}
  }
}
