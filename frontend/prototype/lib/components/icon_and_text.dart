import 'package:flutter/material.dart';
import 'package:prototype/styles/general.dart';

class IconAndText extends StatelessWidget {
  String text;
  IconData icon;
  Color color;
  double flexLevel;
  IconAndText(
      {required this.icon,
      required this.text,
      this.flexLevel = 0,
      this.color = const Color.fromARGB(255, 196, 196, 196)});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, flexLevel, 0),
            child: Icon(
              icon,
              color: color,
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Text(
            text,
            style: TextStyle(
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
