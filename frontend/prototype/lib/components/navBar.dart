import 'package:flutter/material.dart';

import 'package:prototype/screens/contact/_main_view.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';
import 'package:prototype/screens/profile/_main_view.dart';
import 'package:prototype/styles/buttons.dart';
import 'package:prototype/styles/container.dart';
import 'package:prototype/styles/general.dart';
import '../screens/home/_main_view.dart';

/// erzeugt die Navigationsleiste
class NavBar extends StatefulWidget {
  late int currentIndex;
  NavBar(int currentIndex) {
    this.currentIndex = currentIndex;
  }
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final screens = [Home(), NewProject(), Profile(), Contact()];

  final titles = [
    Home().title,
    NewProject().title,
    Profile().title,
    Contact().title
  ];

  /// wählt den Screen aus, zu dem gewechselt werden soll, anhand des Indexwerts, den die
  /// Methode erhält
  _onItemTapped(int index) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => screens[index]),
      (Route<dynamic> route) => false,
    );
  }

  /// ändert die Farbe des Elements der aktuellen Seite in der Navigationsleiste
  Color getCurrentIndexColor(int buttonPosition) {
    if (widget.currentIndex == buttonPosition) {
      return GeneralStyle.getDarkGray();
    } else
      return GeneralStyle.getLightGray();
  }

  /// ändert die Größe des Elements der aktuellen Seite in der Navigationsleiste
  double getCurrentIndexSize(int buttonPosition) {
    if (widget.currentIndex == buttonPosition) {
      return 50;
    } else
      return 30;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.fromLTRB(35, 15, 35, 0),
        decoration: ContainerStyles.borderTop(),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              child: Icon(
                Icons.home,
                color: getCurrentIndexColor(0),
                size: getCurrentIndexSize(0),
              ),
              onTap: () {
                _onItemTapped(0);
              },
            ),
            GestureDetector(
              child: Icon(
                Icons.add_circle_outline,
                color: getCurrentIndexColor(1),
                size: getCurrentIndexSize(1),
              ),
              onTap: () {
                _onItemTapped(1);
              },
            ),
            GestureDetector(
              child: Icon(
                Icons.person,
                color: getCurrentIndexColor(2),
                size: getCurrentIndexSize(2),
              ),
              onTap: () {
                _onItemTapped(2);
              },
            ),
            GestureDetector(
              child: Icon(
                Icons.quick_contacts_mail_outlined,
                color: getCurrentIndexColor(3),
                size: getCurrentIndexSize(3),
              ),
              onTap: () {
                _onItemTapped(3);
              },
            ),
          ],
        ),
      ),
    );
  }
}
