import 'package:flutter/material.dart';
import 'package:prototype/dashboard/projectManager.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dashboard/navBar.dart';

void main() => runApp(RootClass());

class RootClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Color.fromARGB(255, 23, 119, 39),
          backgroundColor: Colors.indigo.shade200,
          textTheme: GoogleFonts.openSansTextTheme()),
      home: NavBar(0),
    );
  }
}
