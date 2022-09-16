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
        decoration: ContainerStyles.roundetCorners(),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Center(
          widthFactor: 1,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}
