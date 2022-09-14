import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:prototype/components/navBar.dart';

import '../styles/container.dart';
import 'appBar_custom.dart';

class CustomScaffoldContainer extends StatelessWidget {
  Widget body;
  CustomAppBar appBar;
  NavBar navBar;
  CustomScaffoldContainer(
      {required this.body, required this.appBar, required this.navBar});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: appBar,
        ),
        Expanded(
          flex: 6,
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            decoration: ContainerStyles.bodyDecoration(),
            child: body,
          ),
        ),
        Expanded(
          flex: 1,
          child: navBar,
        )
      ],
    );
  }
}
