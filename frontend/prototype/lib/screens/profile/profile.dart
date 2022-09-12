import 'package:flutter/material.dart';

import '../../components/navBar.dart';

class Profile extends StatelessWidget {
  String title = "Profil";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            child: Column(
          children: [Text("Profil")],
        )),
        bottomNavigationBar: NavBar(2),
      ),
    );
  }
}
