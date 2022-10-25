import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:msg/services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  test('test app theme change', () async{
    await StorageService.init();
    StorageService.setAppThemeId(true);

    expect((StorageService.getAppThemeId()), true);
  });
}
