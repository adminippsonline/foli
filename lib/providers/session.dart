import 'package:flutter/cupertino.dart';

class Session with ChangeNotifier {
  String _direccion = "";
  String _cp = "";
  String _estado = "";
  String _ciudad = "";
  String _calle = "";
  String _colonia = "";
  String _enCalle = "";
  String _numInt = "";
  String _numExt = "";
  List<int> _cantidad = [];
  List<double> _precios = [];
  double _lat = 0.0;
  double _lng = 0.0;
  bool _reload = false;
  String _payment = "";
  String _pagos = "";
  String _idZona = "";
  String _cliente = "Particular";

  String get cliente => _cliente;
  String get idZona => _idZona;
  String get direccion => _direccion;
  String get cp => _cp;
  String get estado => _estado;
  String get ciudad => _ciudad;
  String get colonia => _colonia;
  String get calle => _calle;
  String get enCalle => _enCalle;
  String get numInt => _numInt;
  String get numExt => _numExt;
  double get lat => _lat;
  double get lng => _lng;
  List<int> get cantidad => _cantidad;
  List<double> get precios => _precios;
  bool get reload => _reload;
  String get payment => _payment;
  String get pagos => _pagos;

 set cliente(String clie){
   _cliente = clie;
   notifyListeners();
 }

  set idZona(String zone){
    _idZona = zone;
    notifyListeners();
  }

  set payment(String payme){
    _payment = payme;
    notifyListeners();
  }

  set pagos(String pag){
    _pagos = pag;
    notifyListeners();
  }


  addCantidad(int cant){
    _cantidad.add(cant);

  }

  addPrecios(double cant){
    _precios.add(cant);

  }


  editCantidad(int index, int cant){
    _cantidad.removeAt(index);
    _cantidad.insert(index, cant);
    _reload = !reload;
    notifyListeners();
  }


  set lat(double l){
    _lat = l;
    notifyListeners();
  }

  set lng(double ln){
    _lng = ln;
    notifyListeners();
  }

  set enCalle(String en){
    _enCalle = en;
    notifyListeners();
  }


  set colonia(String en){
    _colonia = en;
    notifyListeners();
  }

  set numInt(String num){
    _numInt = num;
    notifyListeners();
  }

  set numExt(String numE){
    _numExt = numE;
    notifyListeners();
  }

  set direccion(String direc){
    _direccion = direc;
    notifyListeners();
  }

  set cp(String c){
    _cp = c;
    notifyListeners();
  }

  set estado(String es){
    _estado = es;
    notifyListeners();
  }

  set ciudad(String ci){
    _ciudad = ci;
    notifyListeners();
  }

  set calle(String call){
    _calle = call;
    notifyListeners();
  }


}