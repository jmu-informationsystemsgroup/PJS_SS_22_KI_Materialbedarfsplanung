import 'package:flutter/material.dart';

import '../styles/container.dart';

class CustomButtonRow extends StatelessWidget {
  List<Widget> children;
  Function() onPressed;
  CustomButtonRow({required this.children, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ContainerStyles.getMargin(),
      width: children.length * 55,
      decoration: ContainerStyles.roundetCorners(),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
