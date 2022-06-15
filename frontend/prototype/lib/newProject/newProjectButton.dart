import 'package:flutter/material.dart';

import 'package:prototype/newProject/newNavBar.dart';
import 'mainView.dart';

class AddProjectButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddProjectButtonState();
  }
}

class _AddProjectButtonState extends State<AddProjectButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewProjectNavBar()),
          );
        },
        child: const Text('Neues Projekt anlegen'),
      ),
    );
  }
}
