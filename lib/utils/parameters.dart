
import 'dart:io';

class Parameters {
  bool servicesExceptions(int statusCode) {
    if ((statusCode < 200 || statusCode > 400) && statusCode != 404) {
      return true;
    }
    return false;
  }

  Future<bool> checkInternet()async{
    try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    return true;
    }else{
      return false;
    }
    } on SocketException catch (_) {
    return false;
    }
  }
}