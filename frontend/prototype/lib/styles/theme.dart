import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'general.dart';

class CustomTheme {
  static ThemeData getTheme() {
    return ThemeData(
      textTheme: GoogleFonts.openSansTextTheme(),
      scaffoldBackgroundColor: GeneralStyle.getLightGray(),
      primaryColor: GeneralStyle.getGreen(),
      focusColor: GeneralStyle.getGreen(),
      colorScheme: ColorScheme(
          onPrimary: Colors.white,
          onError: Colors.red,
          error: Colors.red,
          onSurface: Colors.black,
          primary: GeneralStyle.getGreen(),
          surface: GeneralStyle.getGreen(),
          secondary: GeneralStyle.getDarkGray(),
          onSecondary: GeneralStyle.getDarkGray(),
          brightness: Brightness.light,
          background: GeneralStyle.getLightGray(),
          onBackground: GeneralStyle.getLightGray()),
      appBarTheme: appBarStyle(),
      cardTheme: CardTheme(
        shadowColor: Colors.transparent,
      ),
    );
  }

  static AppBarTheme appBarStyle() {
    return const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      foregroundColor: Colors.black,
      titleTextStyle: TextStyle(color: Color.fromARGB(167, 59, 59, 59)
          //  fontFamily: GoogleFonts.changa(),
          ),
    );
  }
}
