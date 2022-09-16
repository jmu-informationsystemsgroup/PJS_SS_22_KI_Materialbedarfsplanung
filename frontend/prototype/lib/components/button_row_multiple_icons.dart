import 'package:flutter/material.dart';

import '../styles/container.dart';

class CustomButtonRow extends StatelessWidget {
  List<Widget> children;
  Function() onPressed;
  CustomButtonRow({
    required this.children,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: ContainerStyles.getMargin(),
        //   width: children.length * 55,
        decoration: ContainerStyles.roundetCorners(),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Wrap(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: children,
        ),
      ),
    );
  }
}
