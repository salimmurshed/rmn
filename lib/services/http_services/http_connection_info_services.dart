import 'package:connectivity_plus/connectivity_plus.dart';

abstract class HttpConnectionInfoServices {
  Future<bool> get isConnected;
}

class HttpConnectionEstablishment implements HttpConnectionInfoServices {
  @override
  Future<bool> get isConnected async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.bluetooth) || connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }else {
      return true;
    }
  }
}
