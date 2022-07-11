import 'package:flutter/material.dart';

import 'package:prototype/archive/mainView.dart';
import 'package:prototype/screen_create_new_project/mainView.dart';
import '../home/mainView.dart';

class NavBar extends StatefulWidget {
  late int currentIndex;
  NavBar(int currentIndex) {
    this.currentIndex = currentIndex;
  }
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final screens = [Dashboard(), NewProject(), Archieve()];

  final titles = [Dashboard().title, NewProject().title, Archieve().title];

  void _onItemTapped(int index) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => screens[index]),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0.0,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_a_photo),
          label: 'Neues Projekt',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.archive),
          label: 'Archiv',
        ),
      ],
      currentIndex: widget.currentIndex,
      onTap: _onItemTapped,
    );
  }
}
