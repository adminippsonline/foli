import 'package:flutter/material.dart';
import 'package:ippsonline/models/pedidosModel.dart';
import 'package:ippsonline/pages/HomePage.dart';
import 'package:ippsonline/utils/parameters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/loginModel.dart';

// ignore: must_be_immutable
class LoadingHomePage extends StatelessWidget {
  String email = "";
  String pass = "";
  LoadingHomePage(this.email, this.pass);
  bool flag = false;
  _loadContacs(BuildContext context) async {
    try {
        await LoginData().loginUser(email, pass);
        await Pedidos().getPedidos(LoginData.user.idAdmin.toString(), LoginData.user.idCrm.toString(),LoginData.user.idPerfil.toString());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));

    } catch (e) {
      print(e);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<dynamic>(
          future: _loadContacs(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Text('Press button to start.');
              case ConnectionState.active:
              case ConnectionState.waiting:
                return  const Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator.adaptive(),
                    SizedBox(height: 15,),
                    Text("Estamos mejorando su experiencia")
                  ],
                ),);
              case ConnectionState.done:
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                return Center(child: Text("Ocurrio un error"),);
            }
          },
        ));
  }
}