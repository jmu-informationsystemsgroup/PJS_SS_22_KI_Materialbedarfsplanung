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
    return Wrap(
      children: [
        Icon(
          icon,
          color: color,
        ),
        Text(" "),
        Text(
          text,
          style: TextStyle(
            color: color,
          ),
        )
      ],
    );
  }
}
