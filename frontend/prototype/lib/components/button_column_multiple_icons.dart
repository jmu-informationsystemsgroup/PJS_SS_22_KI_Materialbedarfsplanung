import 'package:flutter/material.dart';

import '../styles/container.dart';

class CustomButtonColumn extends StatelessWidget {
  List<Widget> children;
  Function() onPressed;
  Color color;
  CustomButtonColumn(
      {required this.children,
      required this.onPressed,
      this.color = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: ContainerStyles.getMargin(),
        decoration: ContainerStyles.roundetCorners(color: this.color),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
