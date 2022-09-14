import 'package:flutter/material.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';

import '../../styles/container.dart';

class QualityChecklist extends StatefulWidget {
  Function(String) changeQuality;
  String value;
  QualityChecklist({required this.changeQuality, this.value = "Q2"});
  @override
  State<StatefulWidget> createState() {
    return _QualityChecklist();
  }
}

class _QualityChecklist extends State<QualityChecklist> {
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  isChecked(String quality) {
    if (quality == widget.value) {
      return true;
    } else {
      return false;
    }
  }

  setQualityState(String quality) {
    widget.value = quality;
  }

  Widget checkBoxRow(String header, String quality) {
    return Wrap(
      alignment: WrapAlignment.start,
      children: <Widget>[
        Text(
          header,
          style: ContainerStyles.getTextStyle(),
        ),
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: isChecked(quality),
          onChanged: (bool? value) {
            setState(() {
              setQualityState(quality);
              widget.changeQuality(quality);
            });
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 3, 15, 7),
      decoration: ContainerStyles.getColoredBoxDecoration(),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 25),
      child: Column(
        children: <Widget>[
          Text(
            "Oberflächenqualität",
            style: ContainerStyles.getTextStyle(),
          ),
          checkBoxRow("\$ (Standard)", "Q2"),
          checkBoxRow("\$\$ (gehobene optische Ansprüche)", "Q3"),
          checkBoxRow("\$\$\$ (höchste optische Ansprüche)", "Q4"),
        ],
      ),
    );
  }
}
