import 'package:flutter/material.dart';

import 'package:prototype/screens/archive/_main_view.dart';
import 'package:prototype/screens/contact/_main_view.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';
import 'package:prototype/styles/buttons.dart';
import '../screens/home/_main_view.dart';

class NavBar extends StatefulWidget {
  late int currentIndex;
  NavBar(int currentIndex) {
    this.currentIndex = currentIndex;
  }
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final screens = [Dashboard(), NewProject(), Archieve(), Contact()];

  final titles = [
    Dashboard().title,
    NewProject().title,
    Archieve().title,
    Contact().title
  ];

  _onItemTapped(int index) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => screens[index]),
      (Route<dynamic> route) => false,
    );
  }

  Color getCurrentIndexColor(int buttonPosition) {
    if (widget.currentIndex == buttonPosition) {
      return Color.fromARGB(255, 0, 0, 0);
    } else
      return Color.fromARGB(80, 0, 0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          child: Icon(
            Icons.home,
            color: getCurrentIndexColor(0),
          ),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(30),
            primary: Colors.white,
            shadowColor: Color.fromARGB(0, 0, 0, 0),
          ),
          onPressed: () {
            _onItemTapped(0);
          },
        ),
        ElevatedButton(
          child: Icon(
            Icons.add_a_photo,
            color: getCurrentIndexColor(1),
            size: 50,
          ),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(30),
            primary: Colors.white,
          ),
          onPressed: () {
            _onItemTapped(1);
          },
        ),
        ElevatedButton(
          child: Icon(
            Icons.archive,
            color: getCurrentIndexColor(2),
          ),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(30),
            primary: Colors.white,
            shadowColor: Color.fromARGB(0, 0, 0, 0),
          ),
          onPressed: () {
            _onItemTapped(2);
          },
        ),
        ElevatedButton(
          child: Icon(
            Icons.quick_contacts_mail_outlined,
            color: getCurrentIndexColor(3),
          ),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(30),
            primary: Colors.white,
            shadowColor: Color.fromARGB(0, 0, 0, 0),
          ),
          onPressed: () {
            _onItemTapped(3);
          },
        ),
      ],
    );
  }
}
