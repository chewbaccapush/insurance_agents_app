import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:msg/services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  test('test saving user login data', () async{
    await StorageService.init();
    StorageService.setLoggedIn(true);

    expect((StorageService.isLoggedIn()), true);
  });
}
