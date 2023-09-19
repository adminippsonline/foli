import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ippsonline/models/detalleVenta.dart';
import 'package:ippsonline/models/ventaModel.dart';
import 'package:ippsonline/pages/printData.dart';

import '../data/login.dart';
import '../models/loginModel.dart';
import '../models/pedidosModel.dart';

class VentasPage extends StatefulWidget {
  const VentasPage({super.key});

  @override
  State<VentasPage> createState() => _VentasPageState();
}

class _VentasPageState extends State<VentasPage> {

  showDetails(int index)async{
    var json = await LoginDataRequest().getDetalleVenta(
        LoginData.user.idAdmin.toString(),
        LoginData.user.idCrm.toString(),
        Venta.ventas[index].idEntrega.toString(),
        Venta.ventas[index].idPv.toString(),
        Venta.ventas[index].idLr.toString()
        );
    List<DetalleVenta> temp = [];
    try{
      for (var i = 0; i < json["data"].length; i++) {
        temp.add(DetalleVenta.fromJson(json["data"][i]));
      }
    }catch(_){}
     showDetalle(temp, index);
  }


  void showDetalle(List<DetalleVenta> detalleVenta, int index){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: detalleVenta.map((e) {
              return ListTile(
                title:  Text(e.nombreDelProducto.toString(), style: TextStyle(fontWeight: FontWeight.w700),),

                subtitle: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                                   Text(e.cantidad.toString() + " X " + "\$"+ e.precioVendido.toString(),style: TextStyle(fontWeight: FontWeight.w300),),
                            Text(e.metodoDePago.toString(),style: TextStyle(fontWeight: FontWeight.w300),),
                            Text(e.tipoDePago.toString(),style: TextStyle(fontWeight: FontWeight.w300),),
                            Text( DateFormat("yyyy-MM-dd").format(e.fechaHora!),style: TextStyle(fontWeight: FontWeight.w300),)
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("\$" + e.total.toString(), style: TextStyle(color: Colors.grey ),),
                            IconButton(onPressed: (){
                              Navigator.of(context).pop();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PrintData(detalleVenta, index)));
                            }, icon: const Icon(Icons.print))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Ventas", style: TextStyle(color: Colors.white),),
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
      ),
      body: ListView.builder(itemBuilder: (context, int index){
        return ListTile(
          onTap: (){
            showDetails(index);
          },
          title: Text(Venta.ventas[index].nombre.toString() + (Venta.ventas[index].nombreDelNegocio.toString().isNotEmpty || Venta.ventas[index].alias.toString().isNotEmpty ? " (" : "") + Venta.ventas[index].nombreDelNegocio.toString() + ((Venta.ventas[index].alias.toString().isNotEmpty ? ("-> " + Venta.ventas[index].alias.toString()) : "") + ((Venta.ventas[index].nombreDelNegocio.toString().isNotEmpty || Venta.ventas[index].alias.toString().isNotEmpty) ? ")" : "")),style: const TextStyle(fontWeight: FontWeight.w700),),
          trailing:  Text(
            "\$" +
                (Venta.ventas[index].total.toString()),
            style: const TextStyle(color: Colors.grey),
          ),
        );
      }, itemCount: Venta.ventas.length,),
    );
  }
}
