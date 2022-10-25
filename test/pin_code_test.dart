import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:msg/services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  test('test pin code', () async{
    await StorageService.init();
    StorageService.setPinCode('0000');

    expect((StorageService.getPinCode()), '0000');
  });
}
