import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityCheker {
  StreamController connectionChangeController = new StreamController.broadcast();
  final Connectivity _connectivity = Connectivity();

  ConnectivityCheker._privateConstructor();
  static final ConnectivityCheker _instance = ConnectivityCheker._privateConstructor();
  

  factory ConnectivityCheker() {
    return _instance;
  }

  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    check();
  }

  void dispose() {
    connectionChangeController.close();
  }

  void _connectionChange(ConnectivityResult result) {
    check();
  }

  Future<bool> check() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      print(e.toString());
    }

    if (result == ConnectivityResult.none) {
      print(false);
      //connectionChangeController.sink.add({result: false});
      connectionChangeController.sink.add(false);
      return false;
    } else {
      print(true);
      // connectionChangeController.sink.add({result: true});
      connectionChangeController.sink.add(true);
      return true;
    }
  }

  Stream get connectionChange => connectionChangeController.stream;
}