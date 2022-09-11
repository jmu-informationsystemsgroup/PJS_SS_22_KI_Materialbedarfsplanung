import 'package:flutter/material.dart';

import '../../components/navBar.dart';

class Profile extends StatelessWidget {
  String title = "Kontakt";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            child: Column(
          children: [Text("Werkzeug und Baustoffhandel")],
        )),
        bottomNavigationBar: NavBar(3),
      ),
    );
  }
}
