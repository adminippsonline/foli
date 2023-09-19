import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ippsonline/data/login.dart';
import 'package:ippsonline/models/zonaModel.dart';
import 'package:ippsonline/providers/session.dart';
import 'package:ippsonline/utils/parameters.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';

import '../models/Image64.dart';
import '../models/loginModel.dart';
import 'Mapa.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController name = TextEditingController();
  TextEditingController apellido = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController celular = TextEditingController();
  TextEditingController alias = TextEditingController();
  TextEditingController nameNegocio = TextEditingController();
  XFile? file;
  Future<void> initData()async{

    List<Placemark> placemarks = await placemarkFromCoordinates(Provider.of<Session>(context,listen: false).lat, Provider.of<Session>(context,listen: false).lng);
    if(placemarks.isNotEmpty){

        Provider.of<Session>(context,listen: false).calle = placemarks.first.street ?? "";
        Provider.of<Session>(context,listen: false).cp = placemarks.first.postalCode ?? "";
        Provider.of<Session>(context,listen: false).direccion = placemarks.first.country ?? "";
        Provider.of<Session>(context,listen: false).ciudad = placemarks.first.locality ?? "";
        Provider.of<Session>(context,listen: false).colonia =  placemarks.first.subLocality ?? "";
        Provider.of<Session>(context,listen: false).estado =  placemarks.first.administrativeArea ?? "";
    }
  }

  bool validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if(value == null || value.isEmpty){
      return false;
    }
    if (!regex.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }


  Widget textInput(TextEditingController _controller, String name, bool filled,
      bool enabled, Function() onPressed, Icon icon) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextFormField(
          controller: _controller,
          inputFormatters: name.contains("Celular")  ? [ MaskTextInputFormatter(
              mask: '## #### ####',
              filter: { "#": RegExp(r'[0-9]') },
              type: MaskAutoCompletionType.lazy
          )] : null,
          maxLength: name.contains("Identificación") ? 13 : null,
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
            fillColor: Colors.grey.withOpacity(0.3),
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
            hintStyle: const TextStyle(
                color: Colors.black),

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
              "Utilizamos la ubicación para poder registrar de mejor manera los datos de dirección de los clientes"),
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

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: const Text("Por favor otorgue accesso a su ubicación en la configuración del sistema"),
            content: Text(
                "Utilizamos la ubicación para poder registrar de mejor manera los datos de dirección de los clientes"),
            actions: [
              TextButton(onPressed: () {
                Geolocator.openAppSettings();
                Navigator.of(context).pop();
              }, child: Text("Ok"))
            ],
          );
        });
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text("Por favor otorgue accesso a su ubicación en la configuración del sistema"),
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

  void registerUser() async {
    CustomProgressDialog progressDialog = CustomProgressDialog(
      context,
      blur: 10,
    );
    //Set loading with red circular progress indicator
    progressDialog.setLoadingWidget(const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.red)));
    progressDialog.show();
    try{
      String nameFile = "${LoginData.user.idPerfil.toString()}_${DateFormat("yyyy_MM_DD_HH_mm_ss").format(DateTime.now())}.jpg";
      Image64 img = Image64(nameFile, XFile(file!.path));
      await img.codeBase64();
      Map data = {
        "id_admin": LoginData.user.idAdmin.toString(),
        "id_CRM": LoginData.user.idCrm.toString(),
        "id_perfil": LoginData.user.idAdmin.toString(),
        "NombreDelNegocio": nameNegocio.text,
        "Alias":alias.text,
        "Archivo": img.imageEncoded,
        "id_zona": Provider.of<Session>(context,listen: false).idZona.toString(),
        "TipoDeCliente":Provider.of<Session>(context,listen: false).cliente.toString(),
        "Nombre": name.text,
        "Apellido":apellido.text,
        "Correo":correo.text,
        "TelefonoCel":celular.text,
        "CP":Provider.of<Session>(context,listen: false).cp,
        "Calle":Provider.of<Session>(context,listen: false).calle,
        "NumExt":Provider.of<Session>(context,listen: false).numExt,
        "NumInt":Provider.of<Session>(context,listen: false).numInt,
        "EntCall":Provider.of<Session>(context,listen: false).enCalle,
        "Pais":Provider.of<Session>(context,listen: false).direccion,
        "Estado":Provider.of<Session>(context,listen: false).estado,
        "MunDel":Provider.of<Session>(context,listen: false).ciudad,
        "Colonia":Provider.of<Session>(context,listen: false).colonia,
        "Lat":Provider.of<Session>(context,listen: false).lat.toString(),
        "Lon":Provider.of<Session>(context,listen: false).lng.toString()
      };
      var result = await LoginDataRequest().registrarUser(data);
      progressDialog.dismiss();
      if(result == 2){
        Provider.of<Session>(context,listen: false).cp = "";
        Provider.of<Session>(context,listen: false).calle = "";
        Provider.of<Session>(context,listen: false).numExt = "";
        Provider.of<Session>(context,listen: false).numInt = "";
        Provider.of<Session>(context,listen: false).enCalle = "";
        Provider.of<Session>(context,listen: false).direccion = "";
        Provider.of<Session>(context,listen: false).estado = "";
        Provider.of<Session>(context,listen: false).ciudad = "";
        Provider.of<Session>(context,listen: false).colonia = "";
        Provider.of<Session>(context,listen: false).lat = 0.0;
        Provider.of<Session>(context,listen: false).lng = 0.0;
        name.text = "";
        celular.text = "";
        correo.text = "";
        apellido.text = "";
        alias.text = "";
        nameNegocio.text = "";
        setState(() {
          file = null;
        });
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            content: Text("Cliente registrado correctamente"),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text("Ok"))
            ],
          );
        });
      }else{
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            content: Text("Ocurrio un error al registrar el cliente"),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text("Ok"))
            ],
          );
        });
      }
    }catch(_){
      progressDialog.dismiss();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(12), bottomLeft: Radius.circular(12))),
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text("REGISTRAR CLIENTE", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
            flexibleSpace: Container(
              decoration:
              const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/logo/background.jpg"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(12), bottomLeft: Radius.circular(12))
              ),
            ),
          ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10,),
              Center(
                child: file != null  ? CircleAvatar(
                  backgroundImage: FileImage(File(file!.path)),
                ) : const SizedBox(),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12)

                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(child: const Text("TOMAR FOTO"), onPressed: ()async{
                       XFile? file2 = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50);
                       setState(() {
                         file = file2;
                       });
                      },),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12)

                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(child: const Text("SELECCIONAR FOTO"), onPressed: ()async{
                        XFile? file2 = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
                        setState(() {
                          file = file2;
                        });
                      },),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              textInput(name, "Nombre", false, true,
                      () {}, const Icon(Icons.person_pin)),
              const SizedBox(
                height: 5,
              ),
              textInput(apellido, "Apellido", false, true, () {},
                  const Icon(Icons.person)),
              const SizedBox(
                height: 5,
              ),
              textInput(alias, "Alias", false, true, () {},
                  const Icon(Icons.person_2)),
              const SizedBox(
                height: 5,
              ),
              textInput(nameNegocio, "Nombre del negocio", false, true,
                      () {}, const Icon(Icons.store)),
              textInput(correo, "Correo", false, true, () {},
                  const Icon(Icons.mail)),
              const SizedBox(
                height: 5,
              ),
              textInput(celular, "Celular", false, true, () {},
                  const Icon(Icons.phone)),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  children: [
                    const Text("ZONA: ", style: TextStyle(fontWeight: FontWeight.bold),),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: Selector<Session, String>(
                        selector: (_, zone) => zone.idZona,
                        builder: (context, zo , __) => DropdownButton(
                          isExpanded: true,
                          items: Zonas.zones.map((e){
                          return DropdownMenuItem(value: e.idZona.toString(),child: Text(e.nombreDeLaZona.toString(), style: TextStyle(color: Colors.black),));
                        }).toList(), onChanged: (a){
                          Provider.of<Session>(context,listen: false).idZona = a.toString();
                        } ,value: Provider.of<Session>(context,listen: false).idZona.isNotEmpty ? Provider.of<Session>(context,listen: false).idZona : null,style: TextStyle(color: Colors.black),alignment: Alignment.center, ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  children: [
                    const Text("TIPO DE CLIENTE: ", style: TextStyle(fontWeight: FontWeight.bold),),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: Selector<Session, String>(
                        selector: (_, zone) => zone.cliente,
                        builder: (context, zo , __) => DropdownButton(
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(child: Text("Particular"), value: "Particular",),
                            DropdownMenuItem(child: Text("Negocio"), value: "Negocio",)
                          ], onChanged: (a){
                          Provider.of<Session>(context,listen: false).cliente = a.toString();
                        } ,value: Provider.of<Session>(context,listen: false).cliente.isNotEmpty ? Provider.of<Session>(context,listen: false).cliente : null,style: const TextStyle(color: Colors.black),alignment: Alignment.center, ),
                      ),
                    ),
                  ],
                ),
              ),

              Consumer<Session>(builder: (context,datos,_){
                return datos.ciudad.isNotEmpty ? Align(
                  alignment: Alignment.centerLeft,
                  child: ListTile(
                    title: const Text("Dirección", style: TextStyle(fontWeight: FontWeight.bold),),
                    trailing: TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Mapa()));
                    },child: const Text("EDITAR", style: TextStyle(color: Colors.blue),),),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text( Provider.of<Session>(context,listen: false).calle),
                          Text( Provider.of<Session>(context,listen: false).colonia),
                          Text( Provider.of<Session>(context,listen: false).enCalle),
                          Text( "Num. Int: "+ Provider.of<Session>(context,listen: false).numInt + " Num. Ext: " + Provider.of<Session>(context,listen: false).numExt),
                          Text( Provider.of<Session>(context,listen: false).cp),
                          Text( Provider.of<Session>(context,listen: false).ciudad),
                          Text( Provider.of<Session>(context,listen: false).estado),
                          Text( Provider.of<Session>(context,listen: false).direccion),

                        ],
                      ),
                    ),
                  ),
                ) : ElevatedButton(onPressed: ()async{
                  var info = await infoPermission();
                  if(info != null){
                    Provider.of<Session>(context,listen: false).lat = info.latitude;
                    Provider.of<Session>(context,listen: false).lng = info.longitude;
                    await initData();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Mapa()));
                  }else{}
                }, child: Text("Seleccionar dirección en el Mapa"));
              }),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: ()async{
        if(await Parameters().checkInternet()){
               if(Provider.of<Session>(context,listen: false).idZona.isNotEmpty){

                 if(file != null){
                   if(Provider.of<Session>(context,listen: false).estado.isNotEmpty){
                     if(name.text.isNotEmpty && correo.text.isNotEmpty && nameNegocio.text.isNotEmpty && alias.text.isNotEmpty && celular.text.isNotEmpty && apellido.text.isNotEmpty){
                       if(validateEmail(correo.text)) {
                         registerUser();
                       }else{
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Escriba un correo valido")));
                       }
                     }else{
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No deje campos vacios")));
                     }
                   }else{
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Agregue una dirección")));
                   }
                 }else{
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Seleccione una imagen")));
                 }


               }else{
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Seleccione una Zona")));
               }
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Se necesita conexión a internet")));
        }
      }, label: const Text("Registrar cliente")),
    );
  }
}
class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  }) {
    assert(mask != null);
    assert(separator != null);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator &&
            newValue.text.substring(newValue.text.length - 1) != separator) {
          return TextEditingValue(
            text:
            '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}