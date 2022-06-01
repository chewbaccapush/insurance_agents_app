import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:msg/screens/home.dart';
import 'package:msg/services/storage_service.dart';
import 'package:msg/services/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:localization/localization.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  bool? theme = await StorageService.getAppTheme();

  runApp(ChangeNotifierProvider(
    child: const MyApp(),
    create: (BuildContext context) => ThemeProvider(isDarkMode: theme!),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();

    StorageService.setLocale(newLocale.languageCode, newLocale.countryCode!);

    state?.setState(() {
      state._locale = newLocale;
    });
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en', 'EN');

  @override
  void initState() {
    super.initState();
    Locale? local = StorageService.getLocale();

    setState(() {
      this._locale = local!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return MaterialApp(
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('de', 'DE'),
          ],
          locale: _locale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate
          ],
          theme: themeProvider.getTheme,
          debugShowCheckedModeBanner: false,
          home: const HomePage());
    });
  }
}
