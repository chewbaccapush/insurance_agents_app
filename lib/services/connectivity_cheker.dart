import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityCheker {
  StreamController connectionChangeController = StreamController.broadcast();
  final Connectivity _connectivity = Connectivity();

  ConnectivityCheker._privateConstructor();
  static final ConnectivityCheker _instance =
      ConnectivityCheker._privateConstructor();

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
      connectionChangeController.sink.add(false);
      return false;
    } else {
      connectionChangeController.sink.add(true);
      return true;
    }
  }

  Stream get connectionChange => connectionChangeController.stream;
}
