import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../data/login.dart';
import '../models/loginModel.dart';
import 'LoginPage.dart';

class WebviewUser extends StatefulWidget {
  String correo = "";
  String pass = "";
  WebviewUser({required this.correo ,required this.pass,super.key});

  @override
  State<WebviewUser> createState() => _WebviewUserState();
}

class _WebviewUserState extends State<WebviewUser> {
  String url = "https://embarques.foli.com.mx/adm/WebViewHtml.php?Correo=demo@purificadora.com&Contrasena=123456";
  late StreamSubscription<Position> positionStream;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateLocation();
  }

  void updateLocation()async{
    var info = await infoPermission();
    if(info != null){
      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      );
      checkLocation();
      positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
              (Position? position) {
            if(position != null){
              sendLocation(position);
            }
          });
    }else{}
  }

  sendLocation(Position position){
    Map a = {
      "id_admin": LoginData.user.idAdmin.toString(),
      "id_CRM": LoginData.user.idCrm.toString(),
      "id_perfil": LoginData.user.idPerfil.toString(),
      "Latitud":position.latitude.toString(),
      "Longitud":position.longitude.toString(),
      "Fecha":DateFormat('yyyy-MM-dd').format(DateTime.now()),
      "Hora":DateFormat('hh:mm').format(DateTime.now()),
    };
    LoginDataRequest().sendLatLng(a);
  }

  void checkLocation(){
    Geolocator.getServiceStatusStream().listen((event) {
      String status = "Desconocido";
      if(event.name == "enabled"){
        status = "Activar";
      }else if(event.name == "disabled"){
        status = "Desactivar";
      }
      Map a ={
        "id_admin": LoginData.user.idAdmin.toString(),
        "id_CRM": LoginData.user.idCrm.toString(),
        "id_perfil": LoginData.user.idPerfil.toString(),
        "hora_desactivar":DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "hora_activar":DateFormat('hh:mm').format(DateTime.now()),
      };
      LoginDataRequest().statusLatLng(a);
    });
  }
  Future<Position?> infoPermission()async{
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      return await showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text("Por favor otorgue accesso a su ubicación"),
          content: Text(
              "Utilizamos la ubicación para poder registrar de mejor manera los datos de dirección de los clientes, ademas de poder realizar tracking correcto de la ruta de los repartidores de los pedidos"),
          actions: [
            TextButton(onPressed: () async{
              Navigator.of(context).pop();
              await _determinePosition();
            }, child: Text("Ok"))
          ],
        );
      });
    }else{
      return _determinePosition();
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text("Por favor active el GPS de su dispositivo"),
          content: Text(
              "Utilizamos la ubicación para poder registrar de mejor manera los datos de dirección de los clientes"),
          actions: [
            TextButton(onPressed: () {
              Geolocator.openLocationSettings();
              Navigator.of(context).pop();
            }, child: Text("Ok"))
          ],
        );
      });
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: ()async{
            launchUrlString("https://www.ippsonline.com/Foli/PoliticasDePrivacidad.php",mode: LaunchMode.externalApplication,webViewConfiguration: WebViewConfiguration(enableDomStorage: true));
          }, icon: const Icon(Icons.policy_rounded, color: Colors.black,)),
          IconButton(onPressed: ()async{
            SharedPreferences shared = await SharedPreferences.getInstance();
            await shared.clear();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
          }, icon: const Icon(Icons.exit_to_app, color: Colors.black,))
        ],
      ),
      body: WebViewWidget(
     controller: WebViewController()
       ..setJavaScriptMode(JavaScriptMode.unrestricted)
       ..loadRequest(Uri.parse("https://embarques.foli.com.mx/adm/WebViewHtml.php?Correo=${widget.correo}&Contrasena=${widget.pass}"))
    )
    );
  }
}
