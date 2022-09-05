import 'package:flutter/material.dart';

import '../styles/container.dart';

class CustomButton extends StatelessWidget {
  List<Widget> children;
  final Function() onPressed;
  CustomButton({required this.children, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ContainerStyles.getMargin(),
      width: 100,
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
