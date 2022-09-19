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
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            width: MediaQuery.of(context).size.width,
            child: appBar,
          ),
        ),
        Expanded(
          flex: 6,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
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
