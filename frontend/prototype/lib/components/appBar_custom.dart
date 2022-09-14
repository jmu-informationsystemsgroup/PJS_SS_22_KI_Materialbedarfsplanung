import 'package:flutter/material.dart';
import 'package:prototype/styles/container.dart';

class CustomAppBar extends StatelessWidget {
  String title;
  List<Widget> subTitle;
  CustomAppBar({required this.title, required this.subTitle});

  Widget getSubTitle() {
    Flex col = Flex(
      direction: Axis.vertical,
      /*
      mainAxisAlignment: MainAxisAlignment.start,
      */
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    subTitle.forEach((element) {
      col.children.add(element);
    });

    return col;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            //   mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: getSubTitle(),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
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
