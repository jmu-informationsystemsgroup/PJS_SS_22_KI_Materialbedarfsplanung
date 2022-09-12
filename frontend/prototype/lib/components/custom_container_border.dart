import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../styles/container.dart';

class CustomContainerBorder extends StatelessWidget {
  Widget child;
  CustomContainerBorder({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      width: double.infinity,
      //   width: BoxWidthStyle.max,
      decoration: ContainerStyles.getBoxDecoration(),
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
    );
  }
}
