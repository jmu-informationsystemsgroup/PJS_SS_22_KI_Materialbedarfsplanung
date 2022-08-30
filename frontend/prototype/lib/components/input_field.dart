import 'package:flutter/material.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';

import '../screens/load_project/create_new_user.dart';
import '../styles/container.dart';

/**
 * gibt ein Textfeld zum Eingeben vom Projektnamen zurück
 */

//TODO rename to inputfield, make more generic using type
class InputField extends StatefulWidget {
  Function(String) saveTo;
  String labelText;
  String value;
  bool mandatory;
  Function(bool)? formComplete;
  InputField(
      {required this.saveTo,
      required this.labelText,
      this.mandatory = false,
      this.formComplete,
      this.value = ""});

  @override
  _InputFieldState createState() {
    return _InputFieldState();
  }
}

class _InputFieldState extends State<InputField> {
  final TextEditingController nameController = TextEditingController();
  bool visibleWarning = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    if (nameController.text.isEmpty && widget.mandatory) {
      setState(() {
        widget.formComplete!(false);
        visibleWarning = true;
      });
    }
    if (nameController.text.isNotEmpty && widget.mandatory) {
      setState(() {
        widget.formComplete!(true);
        visibleWarning = false;
      });
    }
    return Column(
      children: [
        Visibility(
          child: Text(
            widget.labelText + " ist verpflichtend!",
            style: TextStyle(color: Colors.red),
          ),
          visible: visibleWarning,
        ),
        Container(
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
        ),
      ],
    );
  }
}
