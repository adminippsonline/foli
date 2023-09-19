import 'dart:convert';
import 'dart:math';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ippsonline/data/login.dart';
import 'package:ippsonline/models/loginModel.dart';
import 'package:ippsonline/pages/HomePage.dart';
import 'package:ippsonline/pages/WebviewUser.dart';
import 'package:ippsonline/utils/parameters.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/pedidosModel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool seePassword = true;
  Icon seePasswordIcon = const Icon(Icons.visibility_off);
  int select = 0;
  double withSize = 0;
  double heigSize = 0;
  int typeInfo = 0;
  int fails = 1;
  bool form = false;
  TextEditingController codeText = TextEditingController();
  TextEditingController autoLogin = TextEditingController();



  showErrorUser(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  showErrorConexion() {

  }
  void checkLogin()async {
    CustomProgressDialog progressDialog = CustomProgressDialog(
      context,
      blur: 10,
    );
    //Set loading with red circular progress indicator
    progressDialog.setLoadingWidget(const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.red)));
    progressDialog.show();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await LoginData().loginUser(emailController.text, passwordController.text);
    if (LoginData.user.perfil
        .toString()
         != "null") {
      print(LoginData.user.perfil.toString());
        preferences.setBool('isRepartidor', false);
        preferences.setString("email", emailController.text);
        preferences.setString("pass", passwordController.text);
        progressDialog.dismiss();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WebviewUser(correo: emailController.text, pass: passwordController.text)));
    }else{
      progressDialog.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("El usuario no existe")));
    }
  }


  Widget get loginForm => Column(
    children: <Widget>[
      //USERNAME FIELD
      Align(
        alignment: FractionalOffset.bottomCenter,
        child: SizedBox(
          height: 55,
          width: MediaQuery.of(context).size.width * 0.81,
          child: TextField(
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp('(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'))],
            style: TextStyle(
                fontSize: 17,
                color: Colors.black,
                ),
            controller: emailController,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.withOpacity(0.3),
                contentPadding: const EdgeInsets.only(
                    left: 30, right: 10, bottom: 15, top: 0),
                focusedBorder: const OutlineInputBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                      width: 0.5, color: Colors.transparent),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                      width: 0.5, color: Colors.transparent),
                ),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(
                        width: 0.5, color: Colors.transparent)),
                hintText:
                "Correo",
                prefixIcon: const Icon(Icons.person, color: Colors.grey,),
                hintStyle: TextStyle(
                    fontSize: 16,
                     color: Colors.grey)),
          ),
        ),
      ),
      const SizedBox(height: 10,),
      //PASSWORD FIELD
      SizedBox(
        height: 55,
        width: MediaQuery.of(context).size.width * 0.81,
        child: TextFormField(
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp('(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'))],
          style: TextStyle(
              fontSize: 17,
              color: Colors.black,
              ),
          controller: passwordController,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.withOpacity(0.3),
              contentPadding: const EdgeInsets.only(
                  left: 30, right: 10, bottom: 15, top: 0),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(
                    width: 0.5, color: Colors.transparent),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(
                    width: 0.5, color: Colors.transparent),
              ),
              border: const OutlineInputBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                      width: 0.5, color: Colors.transparent)),
              hintText: "Contraseña",
              hintStyle: TextStyle(
                  fontSize: 16, color: Colors.grey),
              prefixIcon: const Icon(Icons.lock, color: Colors.grey,),
              suffixIcon: IconButton(onPressed: (){
                setState(() {
                  if (seePassword) {
                    seePasswordIcon = Icon(Icons.visibility);
                    seePassword = false;
                  } else {
                    seePasswordIcon = Icon(Icons.visibility_off);
                    seePassword = true;
                  }
                });
              }, icon: seePasswordIcon)),
          obscureText: seePassword,
        ),
      ),
      
      const SizedBox(height: 15,),
      ElevatedButton(onPressed: ()async{

        String messageUsuarioIncorrecto = "Por favor ingresa " +
           "usario".toLowerCase() +
            " y contraseña";

        // ignore: await_only_futures
        int isValidPassword = passwordController.text.length;
        int isValidEmail = emailController.text.length;

        if (isValidPassword != 0 && isValidEmail != 0) {
          if(await Parameters().checkInternet()){
          checkLogin();
           }else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Se necesita conexión a internet")));
        }
        } else {
          showErrorUser(messageUsuarioIncorrecto);
        }
      }, child: Text("       Ingresar       ", style: TextStyle(fontSize: 16),),style: ElevatedButton.styleFrom(

      ),),
    ],
  );


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60)
                    )
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60)
                  ),
                    child: Image.asset("assets/logo/logo.jpg", fit: BoxFit.contain,)),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7 - 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20,),
                    const Text("¡Bienvenido", style: TextStyle(color: Colors.black, fontSize: 24,), textAlign: TextAlign.center,),
                    const SizedBox(height: 20,),
                    const SizedBox(height: 15,),
                    loginForm
                  ],
                ),
              ),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage("assets/logo/background.jpg"), fit: BoxFit.fitWidth),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)
                    )
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: GestureDetector(
                    onTap: () {
                         launchUrlString("https://www.ippsonline.com/Foli/PoliticasDePrivacidad.php");

                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Text(
                        "Al ingresar a Foli, estás aceptando nuestros Términos y Condiciones",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}


