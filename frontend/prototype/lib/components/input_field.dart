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
  bool disableMargin;
  IconData? icon;
  TextInputType inputType;
  Function(bool)? formComplete;
  InputField(
      {required this.saveTo,
      required this.labelText,
      this.maxLines = 1,
      this.disableMargin = false,
      this.icon,
      this.inputType = TextInputType.text,
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
    //   _scrollController.dispose();
    super.dispose();
  }

  containerMargin() {
    if (!widget.disableMargin) {
      return ContainerStyles.getMargin();
    } else {
      return EdgeInsets.all(0);
    }
  }

  getRightStyle() {
    if (widget.icon != null) {
      return ContainerStyles.getInputStyleIconGreen(
          widget.labelText, widget.icon!);
    } else {
      return ContainerStyles.getDefaultInputStyleGreen(widget.labelText);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (textController.text.isEmpty && widget.mandatory) {
      widget.formComplete!(false);
      setState(() {
        visibleWarning = true;
      });
    }
    if (textController.text.isNotEmpty && widget.mandatory) {
      widget.formComplete!(true);
      setState(() {
        visibleWarning = false;
      });
    }
    return Column(
      children: [
        Visibility(
          child: Text(
            "Pflicht!",
            style: TextStyle(color: Colors.red),
          ),
          visible: visibleWarning,
        ),
        Container(
          margin: containerMargin(),
          //  height: widget.maxLines * 35.0,
          child: TextFormField(
            //  scrollController: _scrollController,
            keyboardType: widget.inputType,
            controller: textController,
            maxLines: widget.maxLines.toInt(),
            onChanged: (text) {
              //  scrollToCursor(text);
              setState(() {
                widget.saveTo(text);
              });
            },
            decoration: getRightStyle(),
          ),
        ),
      ],
    );
  }
}
