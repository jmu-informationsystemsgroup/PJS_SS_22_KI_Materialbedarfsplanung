import 'package:flutter/material.dart';
import 'package:prototype/styles/general.dart';

class IconAndText extends StatelessWidget {
  String text;
  IconData icon;
  Color color;
  IconAndText(
      {required this.icon,
      required this.text,
      this.color = const Color.fromARGB(255, 196, 196, 196)});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Icon(
            icon,
            color: color,
          ),
        ),
        Expanded(child: Text(" ")),
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
