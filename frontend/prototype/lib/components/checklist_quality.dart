import 'package:flutter/material.dart';
import 'package:prototype/components/custom_container_border.dart';
import 'package:prototype/components/icon_and_text.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';
import 'package:prototype/styles/general.dart';

import '../styles/container.dart';

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
    return GeneralStyle.getUglyGreen();
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
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Checkbox(
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.resolveWith(getColor),
            value: isChecked(quality),
            onChanged: (bool? value) {
              setState(() {
                setQualityState(quality);
                widget.changeQuality(quality);
              });
            },
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            header,
            style: ContainerStyles.getTextStyle(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainerBorder(
      child: Column(
        children: <Widget>[
          IconAndText(
              icon: Icons.verified_outlined, text: "Oberflächenqualität"),
          checkBoxRow("\$ (Standard)", "Q2"),
          checkBoxRow("\$\$ (gehobene optische Ansprüche)", "Q3"),
          checkBoxRow("\$\$\$ (höchste optische Ansprüche)", "Q4"),
        ],
      ),
    );
  }
}
