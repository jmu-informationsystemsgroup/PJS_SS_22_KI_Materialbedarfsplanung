import 'package:flutter/material.dart';

import '../screen_create_new_project/mainView.dart';

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
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => NewProject()),
              (Route<dynamic> route) => false);
        },
        child: const Text('Neues Projekt anlegen'),
      ),
    );
  }
}
