import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:msg/services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  test('test changing locale of app', () async{
    await StorageService.init();
    StorageService.setLocale('de', '');

    expect((StorageService.getLocale()?.languageCode.toString()), 'de');
  });
}
