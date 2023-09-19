import 'dart:convert';

import 'package:ippsonline/data/login.dart';


LoginData loginDataFromJson(String str) => LoginData.fromJson(json.decode(str));

String loginDataToJson(LoginData data) => json.encode(data.toJson());

class LoginData {
  String? status;
  int? code;
  int? total;
  int? idAdmin;
  int? idCrm;
  int? idPerfil;
  String? redireccionar;
  String? perfil;
  Data? data;

  LoginData({
    this.status,
    this.code,
    this.total,
    this.idAdmin,
    this.idCrm,
    this.idPerfil,
    this.redireccionar,
    this.perfil,
    this.data,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    status: json["status"],
    code: json["code"],
    total: json["total"],
    idAdmin: json["id_admin"],
    idCrm: json["id_CRM"],
    idPerfil: json["id_perfil"],
    redireccionar: json["Redireccionar"],
    perfil: json["Perfil"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "total": total,
    "id_admin": idAdmin,
    "id_CRM": idCrm,
    "id_perfil": idPerfil,
    "Redireccionar": redireccionar,
    "Perfil": perfil,
    "data": data?.toJson(),
  };

  static LoginData user = LoginData();
  Future loginUser(String  email, String pass)async{
    LoginData userTemp = LoginData();
    try {
      dynamic json = await LoginDataRequest().loginUser(email, pass);
      if (json is! int) {
        userTemp = LoginData.fromJson(json);
      }
      user = userTemp;
    }catch(w){
      print(w);
    }
    return user;
  }
}

class Data {
  String? nombre;
  String? apellido;
  String? correo;
  String? contrasena;
  String? idPerfilAdm;
  String? idAdmin;
  String? idCrm;
  String? idPerfil;
  dynamic telefonoCelular;

  Data({
    this.nombre,
    this.apellido,
    this.correo,
    this.contrasena,
    this.idPerfilAdm,
    this.idAdmin,
    this.idCrm,
    this.idPerfil,
    this.telefonoCelular,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    nombre: json["Nombre"],
    apellido: json["Apellido"],
    correo: json["Correo"],
    contrasena: json["Contrasena"],
    idPerfilAdm: json["id_perfilAdm"],
    idAdmin: json["id_admin"],
    idCrm: json["id_CRM"],
    idPerfil: json["id_perfil"],
    telefonoCelular: json["TelefonoCelular"],
  );

  Map<String, dynamic> toJson() => {
    "Nombre": nombre,
    "Apellido": apellido,
    "Correo": correo,
    "Contrasena": contrasena,
    "id_perfilAdm": idPerfilAdm,
    "id_admin": idAdmin,
    "id_CRM": idCrm,
    "id_perfil": idPerfil,
    "TelefonoCelular": telefonoCelular,
  };
}
