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
  Function(bool)? formComplete;
  InputField(
      {required this.saveTo,
      required this.labelText,
      this.maxLines = 1,
      this.disableMargin = false,
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
//  ScrollController _scrollController = ScrollController();
  bool visibleWarning = false;

  /*
  String text = '';

  scrollToCursor(String textFieldValue) {
    final isLonger = textFieldValue.length > text.length;
    text = textFieldValue;
    if (isLonger)
      _scrollController.animateTo(_scrollController.position.viewportDimension,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
  }
// use _scrollController.position.viewportDimension if text field is one line
*/

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
          margin: containerMargin(),
          //  height: widget.maxLines * 35.0,
          child: TextFormField(
            //  scrollController: _scrollController,
            controller: textController,
            maxLines: widget.maxLines.toInt(),
            onChanged: (text) {
              //  scrollToCursor(text);
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
