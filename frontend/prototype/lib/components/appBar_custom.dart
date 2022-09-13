import 'package:flutter/material.dart';
import 'package:prototype/styles/container.dart';

class CustomAppBar extends StatelessWidget {
  String title;
  Widget subTitle;
  CustomAppBar({required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: ContainerStyles.marginLeftRight(),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: ContainerStyles.marginLeftRight(),
            child: subTitle,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 50, 10, 0),
            child: Icon(
              Icons.filter_none,
              color: Color.fromARGB(255, 8, 173, 11),
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}
