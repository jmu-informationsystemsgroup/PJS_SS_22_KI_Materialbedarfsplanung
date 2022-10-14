import 'package:flutter/material.dart';

import '../styles/container.dart';
import '../styles/general.dart';

/// erstellt einen Button in den beliebig viele Elemente eingesetzt werden können
class CustomButtonRow extends StatelessWidget {
  List<Widget> children;
  Function() onPressed;
  Color colorOutlined;
  Color colorContent;
  CustomButtonRow({
    required this.children,
    required this.onPressed,
    this.colorOutlined = const Color.fromARGB(255, 8, 173, 11),
    this.colorContent = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: ContainerStyles.getMargin(),
        decoration: ContainerStyles.roundetCorners(color: colorOutlined),
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
