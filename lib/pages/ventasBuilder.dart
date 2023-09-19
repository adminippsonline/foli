import 'package:flutter/material.dart';
import '../models/loginModel.dart';
import '../models/ventaModel.dart';
import 'VentasPage.dart';

// ignore: must_be_immutable
class VentasBuilder extends StatelessWidget {

  bool flag = false;
  _loadVentas(BuildContext context) async {
    try {
      await Venta().getVentas(LoginData.user.idAdmin.toString(), LoginData.user.idCrm.toString(),LoginData.user.idPerfil.toString());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VentasPage()));

    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<dynamic>(
          future: _loadVentas(context),
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
                    Text("Obteniendo ventas")
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