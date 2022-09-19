import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../styles/container.dart';

class CustomContainerBorder extends StatelessWidget {
  Color color;
  Widget child;
  CustomContainerBorder({
    required this.child,
    this.color = const Color.fromARGB(255, 115, 115, 115),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      width: double.infinity,
      //   width: BoxWidthStyle.max,
      decoration: ContainerStyles.getBoxDecoration(color: color),
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
    );
  }
}
