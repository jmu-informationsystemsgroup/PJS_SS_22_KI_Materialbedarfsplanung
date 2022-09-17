import 'package:flutter/material.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';

import '../screens/profile/user_form.dart';
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
  double maxLines;
  Function(bool)? formComplete;
  InputField(
      {required this.saveTo,
      required this.labelText,
      this.maxLines = 2.5,
      this.mandatory = false,
      this.formComplete,
      this.value = ""});

  @override
  _InputFieldState createState() {
    return _InputFieldState();
  }
}

class _InputFieldState extends State<InputField> {
  final TextEditingController textController = TextEditingController();
  bool visibleWarning = false;

  @override
  void initState() {
    super.initState();
    textController.text = widget.value;
  }

  @override
  void dispose() {
    textController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (textController.text.isEmpty && widget.mandatory) {
      setState(() {
        widget.formComplete!(false);
        visibleWarning = true;
      });
    }
    if (textController.text.isNotEmpty && widget.mandatory) {
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
          height: widget.maxLines * 25.0,
          child: TextField(
            controller: textController,
            maxLines: widget.maxLines.toInt(),
            onChanged: (text) {
              setState(() {
                widget.saveTo(text);
              });
            },
            decoration: ContainerStyles.getInputStyleGreen(widget.labelText),
          ),
        ),
      ],
    );
  }
}
