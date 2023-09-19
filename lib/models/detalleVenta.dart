import 'dart:convert';

DetalleVenta detalleVentaFromJson(String str) => DetalleVenta.fromJson(json.decode(str));

String detalleVentaToJson(DetalleVenta data) => json.encode(data.toJson());

class DetalleVenta {
  DateTime? fechaHora;
  String? nombreDelProducto;
  String? cantidad;
  String? tipoDePago;
  String? precioVendido;
  String? subTotal;
  String? total;
  String? metodoDePago;

  DetalleVenta({
    this.fechaHora,
    this.nombreDelProducto,
    this.cantidad,
    this.tipoDePago,
    this.precioVendido,
    this.subTotal,
    this.total,
    this.metodoDePago,
  });

  factory DetalleVenta.fromJson(Map<String, dynamic> json) => DetalleVenta(
    fechaHora: json["FechaHora"] == null ? null : DateTime.parse(json["FechaHora"]),
    nombreDelProducto: json["NombreDelProducto"],
    cantidad: json["Cantidad"],
    tipoDePago: json["TipoDePago"],
    precioVendido: json["PrecioVendido"],
    subTotal: json["SubTotal"],
    total: json["Total"],
    metodoDePago: json["MetodoDePago"],
  );

  Map<String, dynamic> toJson() => {
    "FechaHora": fechaHora?.toIso8601String(),
    "NombreDelProducto": nombreDelProducto,
    "Cantidad": cantidad,
    "TipoDePago": tipoDePago,
    "PrecioVendido": precioVendido,
    "SubTotal": subTotal,
    "Total": total,
    "MetodoDePago": metodoDePago,
  };
}
