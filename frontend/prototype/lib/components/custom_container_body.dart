import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../styles/container.dart';

class CustomContainerBody extends StatelessWidget {
  Widget child;
  CustomContainerBody({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      decoration: ContainerStyles.bodyDecoration(),
      child: child,
    );
  }
}
