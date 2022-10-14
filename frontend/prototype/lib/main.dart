import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prototype/screens/home/_main_view.dart';

import 'package:prototype/styles/general.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:prototype/styles/theme.dart';

/// idee von https://stackoverflow.com/questions/49418332/flutter-how-to-prevent-device-orientation-changes-and-force-portrait
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(RootClass());
  });
}

class RootClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('de', ''),
      ],
      theme: CustomTheme.getTheme(),
      home: Home(),
    );
  }
}
