import 'dart:async';
import 'dart:convert';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:ippsonline/data/login.dart';
import 'package:ippsonline/models/detallePedido.dart';
import 'package:ippsonline/models/pedidosModel.dart';
import 'package:ippsonline/pages/LoginPage.dart';
import 'package:ippsonline/pages/MapaPoints.dart';
import 'package:ippsonline/pages/RegisterPage.dart';
import 'package:ippsonline/pages/ventasBuilder.dart';
import 'package:ippsonline/providers/session.dart';
import 'package:ippsonline/utils/parameters.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/loginModel.dart';
import '../models/zonaModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _advancedDrawerController = AdvancedDrawerController();
 double geTotal(List<Seleccionado>? select){
   double tot = 0.0;
   int index = 0;
   Provider.of<Session>(
       context,
       listen:
       false)
       .precios.forEach((element) {
     tot = tot + ((double.parse(element.toString()) * Provider.of<Session>(
         context,
         listen:
         false)
         .cantidad[index]));
     index = index +1 ;
   });
   return tot;
 }

  void showDetalle(int index){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                      children:
                      Detalle.detalle.data!.map((e) {
                        int index2 =
                        Detalle.detalle.data!.indexOf(e);
                        List<Seleccionado>? select =
                            Detalle.detalle.seleccionados;

                        bool error = false;
                        try {
                          if(Provider.of<Session>(context,
                              listen: false)
                              .cantidad.length != Detalle.detalle.data!.length){
                            Provider.of<Session>(context,
                                listen: false)
                                .addPrecios(double.parse(select!
                                .elementAt(index2)
                                .precio
                                .toString()));
                            Provider.of<Session>(context,
                                listen: false)
                                .addCantidad(int.parse(select!
                                .elementAt(index2)
                                .cantidad
                                .toString()));
                          }

                          int.parse(select!
                              .elementAt(index2)
                              .cantidad
                              .toString());
                          error = false;
                        } catch (_) {
                          if(Provider.of<Session>(context,listen: false).cantidad.length != Detalle.detalle.data!.length){
                            Provider.of<Session>(context,
                                listen: false)
                                .addCantidad(0);
                            Provider.of<Session>(context,
                                listen: false)
                                .addPrecios(double.parse(e.precio.toString()));
                          }
                          error = true;
                        }

                        return ListTile(
                          title: Text(
                            e.nombreDelProducto.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text("Precio: " + "\$" +
                                  (!error ?select!
                                      .elementAt(
                                      index2)
                                      .precio
                                      .toString() : e.precio.toString())),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    mainAxisSize:
                                    MainAxisSize.min,
                                    children: [
                                      Text("Cantidad: "),
                                      SizedBox(
                                        width:
                                        MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.2,
                                        height: 30,
                                        child: TextFormField(
                                          initialValue: Provider.of<Session>(
                                              context,
                                              listen:
                                              false)
                                              .cantidad[
                                          index2]
                                              .toString(),
                                          keyboardType:
                                          TextInputType
                                              .number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .allow(RegExp(
                                                "[0-9]"))
                                          ],
                                          onChanged: (c) {
                                            if (c.isNotEmpty) {
                                              Provider.of<Session>(
                                                  context,
                                                  listen:
                                                  false)
                                                  .editCantidad(
                                                  index2,
                                                  int.parse(
                                                      c));

                                            }else{
                                              Provider.of<Session>(
                                                  context,
                                                  listen:
                                                  false)
                                                  .editCantidad(
                                                  index2,
                                                  0);
                                            }
                                          },
                                          decoration:
                                          InputDecoration(
                                              border:
                                              OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(8),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Consumer<Session>(
                                      builder: (context, _, __) => Text("Total: " +
                                          "\$" +
                                          ((double.parse(Provider.of<Session>(
                                              context,
                                              listen:
                                              false)
                                              .precios[
                                          index2]
                                              .toString()) *
                                              double.parse(Provider.of<Session>(
                                                  context,
                                                  listen:
                                                  false)
                                                  .cantidad[
                                              index2]
                                                  .toString()))
                                              .toString()
                                              ))),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList()),
                  const Divider(),
                  Metodos(),
                  const Divider(),

          Consumer<Session>(
          builder: (context, _, __) => Text("TOTAL: " + "\$"  + geTotal(Detalle.detalle.seleccionados).toString(), style: TextStyle(fontWeight: FontWeight.bold),)
          ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                                "¿Seguro que quieres cancelar el pedido con nombre de ${Pedidos.pedidos.data!.values.elementAt(index).nombre.toString()}?"),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  "No",
                                  style: TextStyle(
                                      color: Colors.black),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(false);
                                },
                              ),
                              TextButton(
                                child: Text(
                                  "Si",
                                  style: TextStyle(
                                      color: Colors.red),
                                ),
                                onPressed: () {
                                  cancelPedidos(
                                      Pedidos.pedidos.data!
                                          .values
                                          .elementAt(
                                          index)
                                          .idLr ??
                                          "",
                                      Pedidos.pedidos.data!
                                          .values
                                          .elementAt(
                                          index)
                                          .idPWeb ??
                                          "",
                                      Pedidos.pedidos.data!
                                          .values
                                          .elementAt(
                                          index)
                                          .idProgramado ??
                                          "");
                                },
                              ),
                            ],
                          );
                        });
                  },
                  child: Text("CANCELAR")),
              TextButton(
                  onPressed: () {
                    if(geTotal(Detalle.detalle.seleccionados) != 0.0){
                      if(Provider.of<Session>(context,listen: false).payment == "Contado" || Provider.of<Session>(context,listen: false).payment == "Credito" ){
                        if(Provider.of<Session>(context,listen: false).pagos.isNotEmpty){
                          entregarPedido(
                              Pedidos.pedidos.data!
                                  .values
                                  .elementAt(
                                  index)
                                  .idLr ??
                                  "",
                              Pedidos.pedidos.data!
                                  .values
                                  .elementAt(
                                  index)
                                  .idPWeb ??
                                  "",
                              Pedidos.pedidos.data!
                                  .values
                                  .elementAt(
                                  index)
                                  .idProgramado ??
                                  "",  Detalle.detalle.idDominio.toString());
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Seleccione un metodo de pago")));
                        }
                      }else if(Provider.of<Session>(context,listen: false).payment == "Vales"){
                        Provider.of<Session>(context,listen: false).pagos = "";
                        entregarPedido(
                            Pedidos.pedidos.data!
                                .values
                                .elementAt(
                                index)
                                .idLr ??
                                "",
                            Pedidos.pedidos.data!
                                .values
                                .elementAt(
                                index)
                                .idPWeb ??
                                "",
                            Pedidos.pedidos.data!
                                .values
                                .elementAt(
                                index)
                                .idProgramado ??
                                "",  Detalle.detalle.idDominio.toString());
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Seleccione un metodo de pago")));
                      }
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Seleccione una cantidad")));
                    }

                  }, child: Text("ENTREGAR"))
            ],
          );
        });
  }

 void entregarPedido(String lr, String web, String programado,
     String dominio) async {
   Navigator.of(context).pop(false);
   int cantidad = 0;
   List<int> elementsIndex = [];
   print(Provider.of<Session>(context,listen: false).cantidad);
   Provider.of<Session>(context,listen: false).cantidad.forEach((element) {
     cantidad = cantidad +element;
     if(element != 0 ){
       elementsIndex.add(Provider.of<Session>(context,listen: false).cantidad.indexOf(element));
     }
   });
   Map<String, dynamic> productos= {};
   elementsIndex.forEach((element) {
     var a = Detalle.detalle.data!.elementAt(element);
     Map<String, dynamic> data =  {
       a.idProducto.toString() : {
         "Puntos": "",
         "id_producto": a.idProducto.toString(),
         "NombreDelProducto": a.nombreDelProducto,
         "PrecioVendido": Provider.of<Session>(context,listen: false).precios.elementAt(element).toString(),
         "id_EntSal": "",
         "Cantidad": Provider.of<Session>(context,listen: false).cantidad.elementAt(element).toString(),
       }
     };
     productos.addAll(data);
   });

   Map entregar = {
     "id_dominio": dominio,
     "id_admin": LoginData.user.idAdmin.toString(),
     "id_CRM": LoginData.user.idCrm.toString(),
     "id_perfil": LoginData.user.idPerfil.toString(),
     "id_LR": lr,
     "id_PWeb": web,
     "id_programado": programado,
     "FolioPersonalizado": "",
     "FechaDeSolicitud": DateFormat('yyyy-MM-dd').format(DateTime.now()),
     "Cantidad":cantidad,
     "SubTotal":geTotal(Detalle.detalle.seleccionados),
     "Total":geTotal(Detalle.detalle.seleccionados),
     "ArrayProductos": productos,
     "TipoDePago": Provider.of<Session>(context,listen: false).payment,
     "MetodoDePago": Provider.of<Session>(context,listen: false).pagos,
     "Referencia": "",
     "Observaciones": "",
   };

   if (await Parameters().checkInternet()) {
     CustomProgressDialog progressDialog = CustomProgressDialog(
       context,
       blur: 10,
     );
     //Set loading with red circular progress indicator
     progressDialog.setLoadingWidget(const CircularProgressIndicator(
         valueColor: AlwaysStoppedAnimation(Colors.red)));
     progressDialog.show();


     int result = await LoginDataRequest().entregarPedido(entregar);

     if (result == 2) {
       await Pedidos().getPedidos(
           LoginData.user.idAdmin.toString(),
           LoginData.user.idCrm.toString(),
           LoginData.user.idPerfil.toString());
       progressDialog.dismiss();
       setState(() {});
       showDialog(
           context: context,
           builder: (context) {
             return AlertDialog(
               content: Text("Pedido entregado correctamente"),
               actions: [
                 TextButton(
                     onPressed: () {
                       Navigator.of(context).pop();
                     },
                     child: Text("Ok"))
               ],
             );
           });
     } else {
       progressDialog.dismiss();
       showDialog(
           context: context,
           builder: (context) {
             return AlertDialog(
               content: Text("Ocurrio un error al entregar el pedido"),
             );
           });
     }
   } else {
     SharedPreferences shared = await SharedPreferences.getInstance();
     if (shared.getStringList("pendingEntregar") == null) {
       shared.setStringList('pendingEntregar', [jsonEncode(entregar)]);
     } else {
       List<String> pending =
       shared.getStringList("pendingEntregar") as List<String>;
       pending.add(jsonEncode(entregar));
       shared.setStringList('pendingEntregar', pending);
     }
     showDialog(
         context: context,
         builder: (context) {
           return AlertDialog(
             content: Text(
                 "El pedido se entregará cuando cuente con conexión a internet"),
             actions: [
               TextButton(
                   onPressed: () {
                     Navigator.of(context).pop();
                   },
                   child: Text("Ok"))
             ],
           );
         });
   }
 }

  void cancelPedidos(String lr, String web, String programado) async {
    Navigator.of(context).pop(false);
    Map cancelar = {
      "id_admin": LoginData.user.idAdmin.toString(),
      "id_CRM": LoginData.user.idCrm.toString(),
      "id_perfil": LoginData.user.idAdmin.toString(),
      "id_LR": lr,
      "id_PWeb": web,
      "id_programado": programado
    };
    if (await Parameters().checkInternet()) {
      CustomProgressDialog progressDialog = CustomProgressDialog(
        context,
        blur: 10,
      );
      //Set loading with red circular progress indicator
      progressDialog.setLoadingWidget(const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.red)));
      progressDialog.show();

      print(cancelar);
      int result = await LoginDataRequest().cancelarPedido(cancelar);

      if (result == 2) {
        await Pedidos().getPedidos(
            LoginData.user.idAdmin.toString(),
            LoginData.user.idCrm.toString(),
            LoginData.user.idPerfil.toString());
        progressDialog.dismiss();
        setState(() {});
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("Pedido cancelado correctamente"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Ok"))
                ],
              );
            });
      } else {
        progressDialog.dismiss();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("Ocurrio un error al cancelar el pedido"),
              );
            });
      }
    } else {
      SharedPreferences shared = await SharedPreferences.getInstance();
      if (shared.getStringList("pendingCancel") == null) {
        shared.setStringList('pendingCancel', [jsonEncode(cancelar)]);
      } else {
        List<String> pending =
            shared.getStringList("pendingCancel") as List<String>;
        pending.add(jsonEncode(cancelar));
        shared.setStringList('pendingCancel', pending);
      }
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                  "El pedido se cancelará cuando cuente con conexión a internet"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Ok"))
              ],
            );
          });
    }
  }
 void entregarPending() async {
   if (await Parameters().checkInternet()) {
     SharedPreferences shared = await SharedPreferences.getInstance();
     if (shared.getStringList("pendingEntregar") != null) {
       if (shared.getStringList("pendingEntregar")!.isNotEmpty) {
         ProgressDialog progressDialog = ProgressDialog(
           context,
           blur: 10,
           title: Text("Entregando pedidos pendientes"),
         );
         progressDialog.show();

         List<String> pending =
         shared.getStringList("pendingEntregar") as List<String>;
         List<String> fails = [];
         for (var pend in pending) {
           print(pend);
           int result =
           await LoginDataRequest().entregarPedido(jsonDecode(pend));
           if (result != 2) {
             fails.add(pend);
           }
         }
         if (fails.isNotEmpty) {
           shared.setStringList("pendingEntregar", fails);
         } else {
           shared.setStringList("pendingEntregar", []);
         }
         await Pedidos().getPedidos(
             LoginData.user.idAdmin.toString(),
             LoginData.user.idCrm.toString(),
             LoginData.user.idPerfil.toString());
         setState(() {});
         progressDialog.dismiss();
         showDialog(
             context: context,
             builder: (context) {
               return AlertDialog(
                 content: Text("Pedidos entregados"),
                 actions: [
                   TextButton(
                       onPressed: () {
                         Navigator.of(context).pop();
                       },
                       child: Text("Ok"))
                 ],
               );
             });
       }
     }
   }
 }
  late StreamSubscription<Position> positionStream;

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
  String _authStatus = 'Unknown';
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    final TrackingStatus status =
    await AppTrackingTransparency.trackingAuthorizationStatus;
    setState(() => _authStatus = '$status');
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Show a custom explainer dialog before the system dialog
      await showCustomTrackingDialog(context);
      // Wait for dialog popping animation
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      final TrackingStatus status =
      await AppTrackingTransparency.requestTrackingAuthorization();
      setState(() => _authStatus = '$status');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("UUID: $uuid");
  }

  Future<void> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Querido usuario'),
          content: const Text(
            'Protegeremos su privacidad. Mantendremos brindandole tranking '
                'Podemos seguir utilizando su información para mejorar el tracking en la app?\n\nPuedes cambiar en cualquier momento en la configuracion de la app en su dispositivo. '
                'Sus datos se utilizan unicamente para mejorar el tracking de pedidos en la app',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continuar'),
            ),
          ],
        ),
      );
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
     "Accion":status,
       "Fecha":DateFormat('yyyy-MM-dd').format(DateTime.now()),
       "Hora":DateFormat('hh:mm').format(DateTime.now()),
   };
     LoginDataRequest().statusLatLng(a);
   });
 }

  void cancelPending() async {
    if (await Parameters().checkInternet()) {
      SharedPreferences shared = await SharedPreferences.getInstance();
      if (shared.getStringList("pendingCancel") != null) {
        if (shared.getStringList("pendingCancel")!.isNotEmpty) {
          ProgressDialog progressDialog = ProgressDialog(
            context,
            blur: 10,
            title: Text("Cancelando pedidos pendientes"),
          );
          progressDialog.show();

          List<String> pending =
              shared.getStringList("pendingCancel") as List<String>;
          List<String> fails = [];
          for (var pend in pending) {
            print(pend);
            int result =
                await LoginDataRequest().cancelarPedido(jsonDecode(pend));
            if (result != 2) {
              fails.add(pend);
            }
          }
          if (fails.isNotEmpty) {
            shared.setStringList("pendingCancel", fails);
          } else {
            shared.setStringList("pendingCancel", []);
          }
          await Pedidos().getPedidos(
              LoginData.user.idAdmin.toString(),
              LoginData.user.idCrm.toString(),
              LoginData.user.idPerfil.toString());
          setState(() {});
          progressDialog.dismiss();
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text("Pedidos cancelados"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          entregarPending();
                        },
                        child: Text("Ok"))
                  ],
                );
              });
        }else{
          entregarPending();
        }
      }else{
        entregarPending();
      }
    }
  }
  showDetails(int index)async{
    var json = await LoginDataRequest().getDetalle(
        LoginData.user.idAdmin.toString(),
        LoginData.user.idCrm.toString(),
        LoginData.user.idPerfil.toString(),
        Pedidos.pedidos.data!.values
            .elementAt(index)
            .idProgramado ??
            "",
        Pedidos.pedidos.data!.values.elementAt(index).idLr ??
            "",
        Pedidos.pedidos.data!.values
            .elementAt(index)
            .idPWeb ??
            "");
    Detalle.detalle = Detalle();
    Detalle.detalle = Detalle.fromJson(json);
    showDetalle(index);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cancelPending();
    updateLocation();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) => initPlugin());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    positionStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        color:const Color(0XFFF25058) ,
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: Container(
        decoration: const BoxDecoration(
          color: Color(0XFFF25058)
        ),
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              Container(
                width: 128.0,
                height: 128.0,
                margin: const EdgeInsets.only(
                  top: 24.0,
                  bottom: 64.0,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/logo/logo.png',
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VentasBuilder()));
                },
                leading: const Icon(Icons.sell),
                title: const Text('Listado de ventas'),
              ),
              ListTile(
                onTap: () async{
                  if (await Parameters().checkInternet()) {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage()));
                  } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Se necesita conexión a internet")));
                  }
                },
                leading: const Icon(Icons.account_circle_rounded),
                title: const Text('Registrar cliente'),
              ),
            ],
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Zonas().getZonas(LoginData.user.idAdmin.toString(), LoginData.user.idCrm.toString());
              _advancedDrawerController.showDrawer();
            },
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/logo/background.jpg"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12))),
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12))),
          title: Text(
            "PEDIDOS",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  SharedPreferences shared =
                      await SharedPreferences.getInstance();
                  await shared.clear();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Pedidos().getPedidos(
                LoginData.user.idAdmin.toString(),
                LoginData.user.idCrm.toString(),
                LoginData.user.idPerfil.toString());
            setState(() {});
          },
          child: Pedidos.pedidos.data != null
              ? ListView.builder(
                  itemCount: Pedidos.pedidos.data?.values.length ?? 0,
                  itemBuilder: (context, int index) {
                    return ListTile(
                      onTap: () async {
                        Provider.of<Session>(context,listen: false).cantidad.clear();
                        Provider.of<Session>(context,listen: false).precios.clear();
                        showDetails(index);
                      },
                      leading: Pedidos.pedidos.data!.values
                          .elementAt(index)
                          .imagen.toString().isNotEmpty && Pedidos.pedidos.data!.values
                          .elementAt(index)
                          .imagen.toString() != "null" ? GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            HeroDialogRoute(
                              builder: (BuildContext context) {
                                final value = ValueNotifier(0);
                                return Center(
                                  child: AlertDialog(
                                    contentPadding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    content: Hero(
                                        tag: Pedidos.pedidos.data!.values
                                            .elementAt(index)
                                            .imagen.toString(),
                                        child: ValueListenableBuilder(
                                          valueListenable: value,
                                          builder: (context, _ , __) => FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: Pedidos.pedidos.data!.values
                                              .elementAt(index)
                                              .imagen.toString(),imageErrorBuilder: (context, _ , __) => const Icon(Icons.image_not_supported_rounded, size: 40,)),
                                        )),

                                  ),
                                );
                              },
                            ),
                          );
                        },
                            child: Hero(
                        tag: Pedidos.pedidos.data!.values
                            .elementAt(index)
                            .imagen.toString(),
                              child: CircleAvatar(
                        backgroundImage: NetworkImage(Pedidos.pedidos.data!.values
                                .elementAt(index)
                                .imagen.toString())
                      ),
                            ),
                          ) : const CircleAvatar(child: Icon(Icons.fire_truck)),
                      subtitle: Text(Pedidos.pedidos.data!.values
                          .elementAt(index)
                          .direccion.toString(), style: const TextStyle(fontWeight: FontWeight.w300),),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "\$" +
                                (Pedidos.pedidos.data!.values
                                    .elementAt(index)
                                    .totalAPagar ?? "0.0"),
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 5,),
                          GestureDetector(
                              onTap: ()async{
                                var info = await infoPermission();
                                if(info != null){
                                  Provider.of<Session>(context,listen: false).lat = info.latitude;
                                  Provider.of<Session>(context,listen: false).lng = info.longitude;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MapaPoints(
                                    double.parse(Pedidos.pedidos.data!.values
                                        .elementAt(index).lat.toString()),
                                      double.parse(Pedidos.pedidos.data!.values
                                          .elementAt(index).lon.toString())
                                  )));
                                }else{}
                              },
                              child: const Icon(Icons.location_on))
                        ],
                      ),
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(Pedidos.pedidos.data!.values
                              .elementAt(index)
                              .nombre
                              .toString() + (Pedidos.pedidos.data!.values
                              .elementAt(index)
                              .alias.toString().isNotEmpty || Pedidos.pedidos.data!.values
                              .elementAt(index)
                              .nombreDelNegocio.toString().isNotEmpty ? " (" : "") + (Pedidos.pedidos.data!.values
                              .elementAt(index)
                              .nombreDelNegocio
                              .toString())  +(Pedidos.pedidos.data!.values
                              .elementAt(index)
                              .alias.toString().isEmpty  ? "" : " -> " + Pedidos.pedidos.data!.values
                              .elementAt(index)
                              .alias.toString()) +(Pedidos.pedidos.data!.values
                              .elementAt(index)
                              .alias.toString().isNotEmpty || Pedidos.pedidos.data!.values
                              .elementAt(index)
                              .nombreDelNegocio.toString().isNotEmpty ? " )" : ""), textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.w700),),
                        ),
                      ),
                    );
                  })
              : const Center(
                  child: Text("No hay ningún pedido"),
                ),
        ),
      ),
    );
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
              Navigator.of(context).pop(await _determinePosition());
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


    return await Geolocator.getCurrentPosition();
  }
}

/*

 */

class Metodos extends StatelessWidget {
  const Metodos({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<Session, String>(
      selector: (_, selec) => selec.payment,
      builder: (context, data, __) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              RadioListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: "Contado",
                groupValue: data,
                onChanged: (val) {
                  Provider.of<Session>(context,
                      listen: false)
                      .payment = val.toString();
                },
                title: Text("Pago de contado",style: TextStyle(fontWeight: FontWeight.w600)),
              ),
              data == "Contado"
                  ? Pagos()
                  : const SizedBox(),
            ],
          ),
          RadioListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: "Vales",
            groupValue: data,
            onChanged: (val) {
              Provider.of<Session>(context,
                  listen: false)
                  .payment = val.toString();
            },
            title: Text("Pago con vales",style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Column(
            children: [
              RadioListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: "Credito",
                groupValue: data,
                onChanged: (val) {
                  Provider.of<Session>(context,
                      listen: false)
                      .payment = val.toString();
                },
                title: Text("Credito", style: TextStyle(fontWeight: FontWeight.w600),),
              ),
              data == "Credito"
                  ? Pagos()
                  : const SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}


class Pagos extends StatelessWidget {
  const Pagos({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<Session,String>(
      selector: (_, select) => select.pagos,
      builder: (context, data, _) => Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(
          children: [
            RadioListTile.adaptive(
              value: "Pago en efectivo",
              groupValue: data,
              onChanged: (val) {
                Provider.of<Session>(context,
                    listen: false)
                    .pagos = val.toString();
              },
              title: Text("Pago en efectivo", style: TextStyle(fontWeight: FontWeight.w300),),
            ),
            RadioListTile.adaptive(
              value: "Pago en transferencia",
              groupValue: data,
              onChanged: (val) {
                Provider.of<Session>(context,
                    listen: false)
                    .pagos = val.toString();
              },
              title: Text("Pago en transferencia",style: TextStyle(fontWeight: FontWeight.w300),),
            ),
          ],
        ),
      ),
    );
  }



}


class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({ required this.builder }) : super();

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
        opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut
        ),
        child: child
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  // TODO: implement barrierLabel
  String? get barrierLabel => "";

}