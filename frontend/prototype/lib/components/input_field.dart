import 'package:flutter/material.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';

import '../styles/container.dart';

/**
 * gibt ein Textfeld zum Eingeben vom Projektnamen zurück
 */

//TODO rename to inputfield, make more generic using type
class InputField extends StatefulWidget {
  Function(String) saveTo;
  String labelText;
  String value;
  InputField({required this.saveTo, required this.labelText, this.value = ""});

  @override
  _InputFieldState createState() {
    return _InputFieldState();
  }
}

class _InputFieldState extends State<InputField> {
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ContainerStyles.getMargin(),
      child: TextField(
        controller: nameController,
        onChanged: (text) {
          setState(() {
            widget.saveTo(text);
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: widget.labelText,
        ),
      ),
    );
  }
}
