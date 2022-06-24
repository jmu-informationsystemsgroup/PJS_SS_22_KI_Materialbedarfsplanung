import 'package:flutter/material.dart';

import 'package:prototype/archived/archive.dart';
import 'package:prototype/newProject/mainView.dart';
import 'projectManager.dart';

class NavBar extends StatefulWidget {
  int startingPoint;
  NavBar(this.startingPoint);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final screens = [ProjectManager(), NewProject(), Archieve()];

  final titles = [ProjectManager().title, NewProject().title, Archieve().title];

  void _onItemTapped(int index) {
    setState(() {
      widget.startingPoint = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screens[widget.startingPoint],
        bottomNavigationBar: BottomNavigationBar(
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
          currentIndex: widget.startingPoint,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
