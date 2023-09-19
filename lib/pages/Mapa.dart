import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ippsonline/providers/session.dart';
import 'package:provider/provider.dart';

class Mapa extends StatefulWidget {
  Mapa({super.key});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  TextEditingController a = TextEditingController();
  TextEditingController b = TextEditingController();
  TextEditingController c = TextEditingController();
  TextEditingController d = TextEditingController();
  TextEditingController e = TextEditingController();
  TextEditingController f = TextEditingController();
  TextEditingController g = TextEditingController();
  TextEditingController h = TextEditingController();
  TextEditingController i = TextEditingController();
  final lats = ValueNotifier(0.0);
  final lngs = ValueNotifier(0.0);



  Widget textInput( int type ,String name, bool filled,
      bool enabled, Function() onPressed, Icon icon, context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextFormField(
          maxLength: name.contains("Identificación") ? 13 : null,
          controller: type == 0 ? a : type == 1 ? b: type == 2 ? c : type == 3 ? d : type == 8 ? e : type == 9 ? f : type == 5 ? g : type == 6 ? h : type == 7 ? i : null  ,
          onChanged: (a){
            if(type == 0){
              Provider.of<Session>(context,listen: false).calle = a;
            }else if(type == 1 ){
              Provider.of<Session>(context,listen: false).ciudad = a;
            }else if(type == 2){
              Provider.of<Session>(context,listen: false).colonia = a;
            }else if(type == 3){
              Provider.of<Session>(context,listen: false).cp = a;
            }else if(type == 5){
              Provider.of<Session>(context,listen: false).enCalle = a;
            }else if(type == 6){
              Provider.of<Session>(context,listen: false).numInt = a;
            }else if(type == 7){
              Provider.of<Session>(context,listen: false).numExt = a;
            }else if(type == 8){
              Provider.of<Session>(context,listen: false).direccion = a;
            }else if(type == 9){
              Provider.of<Session>(context,listen: false).estado = a;
            }
          },
          enabled: enabled,
          maxLines: 1,
          keyboardType: name.contains("Celular")  ? TextInputType.phone : name.contains("Correo") ? TextInputType.emailAddress : TextInputType.text,
          cursorColor: filled == true ? Colors.grey : Colors.white,
          textCapitalization: (name.contains("NOMBRE")
              ? TextCapitalization.words
              : TextCapitalization.none),
          style: TextStyle(
              fontSize: 15.0,
              color: Colors.black),
          decoration: InputDecoration(
            counterText: "",
            hintText: name,
            filled: true,
            prefixIcon: icon,
            fillColor:  Colors.grey.withOpacity(0.3) ,
            disabledBorder: const UnderlineInputBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(12)),
                borderSide:
                BorderSide(width: 1.0, color: Colors.transparent)),
            enabledBorder: const UnderlineInputBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(12)),
                borderSide:
                BorderSide(width: 1.0, color: Colors.transparent)),
            focusedBorder: const UnderlineInputBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(12)),
                borderSide:
                BorderSide(width: 1.0, color: Colors.transparent)),
            hintStyle:  TextStyle(
                color: (type == 0 ? a : type == 1 ? b: type == 2 ? c : type == 3 ? d : type == 8 ? e : type == 9 ? f : type == 5 ? g : type == 6 ? h : type == 7 ? i : null )!.text.isNotEmpty ? Colors.black : Colors.grey),

          ),
        ),
      ),
    );
  }

  initData(double lat, double lng)async{

    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    if(placemarks.isNotEmpty){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<Session>(context,listen: false).calle = placemarks.first.street ?? "";
        a.text  = Provider.of<Session>(context,listen: false).calle;
        Provider.of<Session>(context,listen: false).ciudad = placemarks.first.locality ?? "";
        b.text  = Provider.of<Session>(context,listen: false).ciudad;
        Provider.of<Session>(context,listen: false).colonia = placemarks.first.subLocality ?? "";
        c.text  = Provider.of<Session>(context,listen: false).colonia;
        Provider.of<Session>(context,listen: false).cp = placemarks.first.postalCode ?? "";
        d.text  = Provider.of<Session>(context,listen: false).cp;

        Provider.of<Session>(context,listen: false).estado =  placemarks.first.administrativeArea ?? "";
        f.text  = Provider.of<Session>(context,listen: false).estado;

        Provider.of<Session>(context,listen: false).direccion = placemarks.first.country ?? "";
        e.text  = Provider.of<Session>(context,listen: false).direccion;



      });
    }
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    a.text  = Provider.of<Session>(context,listen: false).calle;
    b.text  = Provider.of<Session>(context,listen: false).ciudad;
    c.text  = Provider.of<Session>(context,listen: false).colonia;
    d.text  = Provider.of<Session>(context,listen: false).cp;
    e.text  = Provider.of<Session>(context,listen: false).direccion;
    f.text  = Provider.of<Session>(context,listen: false).estado;
    g.text = Provider.of<Session>(context,listen: false).enCalle;
    h.text = Provider.of<Session>(context,listen: false).numInt;
    i.text = Provider.of<Session>(context,listen: false).numExt;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()  async => false,
      child: Scaffold(
        appBar: AppBar(title: Text("Seleccionar ubicación"),),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(target: LatLng(Provider.of<Session>(context,listen: false).lat, Provider.of<Session>(context,listen: false).lng),zoom: 17),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    onCameraIdle: (){
                       if(lats.value != 0.0) {
                         initData(lats.value, lngs.value);
                       }
                    },
                    onCameraMove: (a){
                      lats.value = a.target.latitude;
                      lngs.value = a.target.longitude;
                      Provider.of<Session>(context,listen: false).lat = a.target.latitude;
                      Provider.of<Session>(context,listen: false).lng = a.target.longitude;
                    },
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.pin_drop_rounded),
                  ),

                ],
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      textInput(0, "Calle", false, true,
                              () {}, const Icon(Icons.person), context),
                      const SizedBox(
                        height: 5,
                      ),
                      textInput(1, "Ciudad", false, true,
                              () {}, const Icon(Icons.person), context),
                      const SizedBox(
                        height: 5,
                      ),
                      textInput(2, "Colonia", false, true,
                              () {}, const Icon(Icons.person), context),
                      const SizedBox(
                        height: 5,
                      ),
                      textInput(3, "CP", false, true,
                              () {}, const Icon(Icons.person),context),
                      const SizedBox(
                        height: 5,
                      ),
                      textInput(9, "Estado", false, true,
                              () {}, const Icon(Icons.person),context),
                      const SizedBox(
                        height: 5,
                      ),
                      textInput(8, "Pais", false, true,
                              () {}, const Icon(Icons.person),context),
                      const SizedBox(
                        height: 5,
                      ),
                      textInput(5, "Entre calles", false, true,
                              () {}, const Icon(Icons.person),context),
                      const SizedBox(
                        height: 5,
                      ),
                      textInput(6, "Número interior", false, true,
                              () {}, const Icon(Icons.person),context),
                      const SizedBox(
                        height: 5,
                      ),
                      textInput(7, "Número exterior", false, true,
                              () {}, const Icon(Icons.person),context),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(onPressed: (){
          if(Provider.of<Session>(context,listen: false).calle.isNotEmpty
              && Provider.of<Session>(context,listen: false).ciudad.isNotEmpty
              && Provider.of<Session>(context,listen: false).colonia.isNotEmpty
              && Provider.of<Session>(context,listen: false).cp.isNotEmpty
              && Provider.of<Session>(context,listen: false).enCalle.isNotEmpty
              && Provider.of<Session>(context,listen: false).numInt .isNotEmpty
              && Provider.of<Session>(context,listen: false).numExt .isNotEmpty
              &&  Provider.of<Session>(context,listen: false).direccion.isNotEmpty
              && Provider.of<Session>(context,listen: false).estado.isNotEmpty){
              if(lats.value != 0.0){
                Provider.of<Session>(context,listen: false).lat = lats.value;
                Provider.of<Session>(context,listen: false).lng = lngs.value;
              }
              Navigator.of(context).pop();
          }else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No deje campos vacios")));
          }

        }, label: Text("GUARDAR")),
      ),
    );
  }
}
