import 'package:flutter/material.dart';
import 'package:prototype/localDrive/content.dart';
import 'package:prototype/newProject/saveTest.dart';

enum InputType { projectName, client }

/**
 * gibt ein Textfeld zum Eingeben vom Projektnamen zurück
 */

//TODO rename to inputfield, make more generic using type
class InputField extends StatefulWidget {
  late Enum type;
  InputField(this.type, {Key? key}) : super(key: key);

  String getLabelText() {
    if (type == InputType.projectName) {
      return "Projektname";
    } else if (type == InputType.client) {
      return "Auftraggeber";
    }
    return "";
  }

  void setStateLocation(String text) {
    if (type == InputType.projectName) {
      SaveTest.cash.newProjectName = text;
    } else if (type == InputType.client) {
      SaveTest.cash.client = text;
    }
  }

  @override
  _InputFieldState createState() {
    return _InputFieldState(type);
  }
}

class _InputFieldState extends State<InputField> {
  late Enum type;
  _InputFieldState(this.type);

  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: TextField(
        controller: nameController,
        onChanged: (text) {
          setState(() {
            InputField(type).setStateLocation(text);
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: InputField(type).getLabelText(),
        ),
      ),
    );
  }
}
