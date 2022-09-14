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
        Stack(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: subTitle,
            ),
          ],
        ),
        Positioned(
          top: 30,
          right: 0,
          child: Icon(
            Icons.filter_none,
            color: Color.fromARGB(255, 8, 173, 11),
            size: 60,
          ),
        ),
      ],
    );
  }
}
