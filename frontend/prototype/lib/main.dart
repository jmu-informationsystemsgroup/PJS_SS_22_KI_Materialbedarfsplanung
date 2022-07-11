import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:prototype/home/_main_view.dart';
import 'package:google_fonts/google_fonts.dart';

// TODO: initialflutter binding
void main() => runApp(RootClass());

class RootClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(),
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: navBarStyle(),
        appBarTheme: appBarStyle(),
        cardTheme: CardTheme(
          shadowColor: Colors.transparent,
        ),
      ),
      home: Dashboard(),
    );
  }

  BottomNavigationBarThemeData navBarStyle() {
    return const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      selectedIconTheme: IconThemeData(color: Colors.black),
      unselectedItemColor: Color.fromARGB(62, 0, 0, 0),
    );
  }

  AppBarTheme appBarStyle() {
    return const AppBarTheme(
      toolbarHeight: 90,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      foregroundColor: Colors.black,
      titleTextStyle: TextStyle(
        color: Color.fromARGB(167, 59, 59, 59),
        fontSize: 18,
        //  fontFamily: GoogleFonts.changa(),
      ),
    );
  }

  static Ink customButtonStyle(String text) {
    return Ink(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color.fromARGB(255, 36, 0, 107),
            Color.fromARGB(175, 36, 0, 107)
          ], // Gradient from https://learnui.design/tools/gradient-generator.html
          tileMode: TileMode.mirror,
        ),
        borderRadius: BorderRadius.all(Radius.circular(80.0)),
      ),
      child: Container(
        constraints: const BoxConstraints(
            minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
