import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:http/http.dart' as http;
import '../../utils/parameters.dart';

class LoginDataRequest{
   String url = "https://embarques.foli.com.mx:4433/adm/WebViewLogin.php";
   String urlPedidos = "https://aguabudelli.com/adm/ApiApp/Pedidos.php";
   String urlCancelar = "https://aguabudelli.com/adm/ApiApp/PedidosCancelar.php";
   String urlRegistro = "https://aguabudelli.com/adm/ApiApp/Registro.php";
   String urlDetalle = "https://aguabudelli.com/adm/ApiApp/PedidosDetalle.php";
   String urlEntregar = "https://aguabudelli.com/adm/ApiApp/PedidosEntregar.php";
   String urlVentas = "https://aguabudelli.com/adm/ApiApp/Ventas.php";
   String urlVentasDetalle = "https://aguabudelli.com/adm/ApiApp/VentasDetalle.php";
   String urlZonas = "https://aguabudelli.com/adm/ApiApp/Zonas.php";
   String urlGeo = "https://embarques.foli.com.mx:4433/adm/AppiCoordenadas/RecibirGeolocalizacion.php";
   String urlDesact = "https://embarques.foli.com.mx:4433/adm/AppiCoordenadas/ActivarDesactivarGeolocalizacion.php";
   DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
   Options _cacheOptions = buildCacheOptions(Duration(days: 7),forceRefresh: true);
   Dio _dio = Dio();

   Future loginUser(String correo, String contrasena)async{

     _dio.interceptors.add(_dioCacheManager.interceptor);
     Map use = {
       "Correo": correo,
       "Contrasena": contrasena
     };
     Response response = await _dio.post(url,data: json.encode(use),options: _cacheOptions);
     print(response.data);
     int statusCode = response.statusCode as int;
     if (Parameters().servicesExceptions(statusCode)) {
       return Future.value(0);
     } else {
       if (statusCode == 404) {
         return Future.value(1);
       } else {
         return Future.value(jsonDecode(response.data));
       }
     }

   }

   Future getPedidos(String admin, String crm, String perfil)async{
     Map use = {
       "id_admin": admin,
       "id_CRM": crm,
       "id_perfil": perfil
     };
     _dio.interceptors.add(_dioCacheManager.interceptor);
     Response response = await _dio.post(urlPedidos,data: json.encode(use),options: _cacheOptions);
     print(response.data);
     int statusCode = response.statusCode as int;
     if (Parameters().servicesExceptions(statusCode)) {
       return Future.value(0);
     } else {
       if (statusCode == 404) {
         return Future.value(1);
       } else {
         return Future.value(jsonDecode(response.data));
       }
     }
   }

   Future getVentas(String admin, String crm, String perfil)async{
     Map use = {
       "id_admin": admin,
       "id_CRM": crm,
       "id_perfil": perfil
     };
     _dio.interceptors.add(_dioCacheManager.interceptor);
     Response response = await _dio.post(urlVentas,data: json.encode(use),options: _cacheOptions);
     int statusCode = response.statusCode as int;
     if (Parameters().servicesExceptions(statusCode)) {
       return Future.value(0);
     } else {
       if (statusCode == 404) {
         return Future.value(1);
       } else {
         return Future.value(jsonDecode(response.data));
       }
     }
   }

   Future getDetalleVenta(String admin, String crm, String entrega, String pv, String lt)async{
     Map use = {
       "id_admin": admin,
       "id_CRM": crm,
       "id_entrega":entrega,
       "id_PV":pv,
       "id_LR":lt
     };
     _dio.interceptors.add(_dioCacheManager.interceptor);
     Response response = await _dio.post(urlVentasDetalle,data: json.encode(use),options: _cacheOptions);
     int statusCode = response.statusCode as int;
     if (Parameters().servicesExceptions(statusCode)) {
       return Future.value(0);
     } else {
       if (statusCode == 404) {
         return Future.value(1);
       } else {
         return Future.value(jsonDecode(response.data));
       }
     }
   }

   Future getDetalle(String admin, String crm, String perfil, String pro, String lt, String web)async{
     Map use = {};
     if(pro != ""){
       use = {
         "id_admin": admin,
         "id_CRM": crm,
         "id_programado": pro,
         "id_LR": lt
       };
     }else if(web != ""){
       use = {
         "id_admin": admin,
         "id_CRM": crm,
         "id_PWeb": web,
         "id_LR": lt
       };
     }
     _dio.interceptors.add(_dioCacheManager.interceptor);
     Response response = await _dio.post(urlDetalle,data: json.encode(use),options: _cacheOptions);
     int statusCode = response.statusCode as int;
     if (Parameters().servicesExceptions(statusCode)) {
       return Future.value(0);
     } else {
       if (statusCode == 404) {
         return Future.value(1);
       } else {
         return Future.value(jsonDecode(response.data));
       }
     }
   }

   Future getZonas(String admin, String crm)async{
     Map use = {
       "id_admin": admin,
       "id_CRM": crm
     };
     _dio.interceptors.add(_dioCacheManager.interceptor);
     Response response = await _dio.post(urlZonas,data: json.encode(use),options: _cacheOptions);
     int statusCode = response.statusCode as int;
     if (Parameters().servicesExceptions(statusCode)) {
       return Future.value(0);
     } else {
       if (statusCode == 404) {
         return Future.value(1);
       } else {
         return Future.value(jsonDecode(response.data));
       }
     }
   }

   Future sendLatLng(Map data){
     return http.post(
         Uri.parse(urlGeo),
         body: json.encode(data),
         headers: {
           "Content-Type": "application/json",
         }).then((http.Response response) async{
       final int statusCode = response.statusCode;
       if (Parameters().servicesExceptions(statusCode)) {
         return Future.value(0);
       } else {
         if (statusCode == 404) {
           return Future.value(1);
         } else {
           if(statusCode == 200){
             return Future.value(2);
           }else{
             return Future.value(3);
           }

         }
       }
     });
   }

   Future statusLatLng(Map data){
     return http.post(
         Uri.parse(urlDesact),
         body: json.encode(data),
         headers: {
           "Content-Type": "application/json",
         }).then((http.Response response) async{
       final int statusCode = response.statusCode;
       if (Parameters().servicesExceptions(statusCode)) {
         return Future.value(0);
       } else {
         if (statusCode == 404) {
           return Future.value(1);
         } else {
           if(statusCode == 200){
             return Future.value(2);
           }else{
             return Future.value(3);
           }

         }
       }
     });
   }

   Future cancelarPedido(Map cancelar){
     return http.post(
         Uri.parse(urlCancelar),
         body: json.encode(cancelar),
         headers: {
           "Content-Type": "application/json",
         }).then((http.Response response) async{
       final int statusCode = response.statusCode;
       if (Parameters().servicesExceptions(statusCode)) {
         return Future.value(0);
       } else {
         if (statusCode == 404) {
           return Future.value(1);
         } else {
           if(jsonDecode(response.body)["msg"] == "Cancelado correctamente"){
             return Future.value(2);
           }else{
             return Future.value(3);
           }

         }
       }
     });
   }

   Future entregarPedido(Map entregar){
     return http.post(
         Uri.parse(urlEntregar),
         body: json.encode(entregar),
         headers: {
           "Content-Type": "application/json",
         }).then((http.Response response) async{
       final int statusCode = response.statusCode;
       print(response.body);
       if (Parameters().servicesExceptions(statusCode)) {
         return Future.value(0);
       } else {
         if (statusCode == 404) {
           return Future.value(1);
         } else {
           if(statusCode == 200){
             return Future.value(2);
           }else{
             return Future.value(3);
           }

         }
       }
     });
   }

   Future registrarUser(Map registro){
     return http.post(
         Uri.parse(urlRegistro),
         body: json.encode(registro),
         headers: {
           "Content-Type": "application/json",
         }).then((http.Response response) async{
       final int statusCode = response.statusCode;
       print(response.body);
       if (Parameters().servicesExceptions(statusCode)) {
         return Future.value(0);
       } else {
         if (statusCode == 404) {
           return Future.value(1);
         } else {
           if(statusCode == 200){
             return Future.value(2);
           }else{
             return Future.value(3);
           }

         }
       }
     });
   }

}