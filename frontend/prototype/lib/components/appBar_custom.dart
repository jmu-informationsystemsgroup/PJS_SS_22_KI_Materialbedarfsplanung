import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  String title;
  CustomAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            this.title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(
            Icons.filter_none,
            color: Color.fromARGB(255, 8, 173, 11),
            size: 30,
          )
        ],
      ),
    );
  }
}
