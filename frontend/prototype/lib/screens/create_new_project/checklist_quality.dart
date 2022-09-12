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
  bool isCheckedQ2 = true;
  bool isCheckedQ3 = false;
  bool isCheckedQ4 = false;

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

  @override
  void initState() {
    super.initState();
    if (widget.value == "Q2") {
      isCheckedQ2 = true;
      isCheckedQ3 = false;
      isCheckedQ4 = false;
    } else if (widget.value == "Q3") {
      isCheckedQ2 = false;
      isCheckedQ3 = true;
      isCheckedQ4 = false;
    } else if (widget.value == "Q3") {
      isCheckedQ2 = false;
      isCheckedQ3 = false;
      isCheckedQ4 = true;
    }
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
          Row(
            children: <Widget>[
              Text(
                "\$ (Standard)",
                style: ContainerStyles.getTextStyle(),
              ),
              Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: isCheckedQ2,
                onChanged: (bool? value) {
                  setState(() {
                    isCheckedQ2 = value!;
                    isCheckedQ3 = false;
                    isCheckedQ4 = false;
                    widget.changeQuality("Q2");
                  });
                },
              )
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                "\$\$ (gehobene optische Ansprüche)",
                style: ContainerStyles.getTextStyle(),
              ),
              Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: isCheckedQ3,
                onChanged: (bool? value) {
                  setState(() {
                    isCheckedQ3 = value!;
                    isCheckedQ2 = false;
                    isCheckedQ4 = false;
                    widget.changeQuality("Q3");
                  });
                },
              )
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                "\$\$\$ (höchste optische Ansprüche)",
                style: ContainerStyles.getTextStyle(),
              ),
              Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: isCheckedQ4,
                onChanged: (bool? value) {
                  setState(() {
                    isCheckedQ4 = value!;
                    isCheckedQ2 = false;
                    isCheckedQ3 = false;
                    widget.changeQuality("Q4");
                  });
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
