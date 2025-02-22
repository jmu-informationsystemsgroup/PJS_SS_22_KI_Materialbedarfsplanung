import 'package:flutter/material.dart';
import 'package:prototype/styles/container.dart';

/// UI-Element für den oberen (hellgrauen) Bereich der App
class CustomAppBar extends StatelessWidget {
  String title;
  List<Widget> subTitle;
  CustomAppBar({required this.title, required this.subTitle});

  /// gibt die Überschriften der App-Bar zurück
  Widget getTitles() {
    Flex col = Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.end,
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
        SizedBox(
          height: 8,
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
    return Stack(
      children: [
        Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: ContainerStyles.getMargin(),
              child: SingleChildScrollView(child: getTitles()),
            )),
        Positioned(
          top: 20,
          right: 0,
          child: SizedBox(
            width: 50,
            child: Image.asset("assets/logo.jpg"),
          ),
        ),
      ],
    );
  }
}
