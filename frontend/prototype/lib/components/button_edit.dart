import 'package:flutter/material.dart';

import '../styles/container.dart';
import '../styles/general.dart';

class ButtonEdit extends StatelessWidget {
  bool textVisiblity;
  Function() changeState;
  ButtonEdit({required this.textVisiblity, required this.changeState});

  IconData getIcon() {
    if (textVisiblity) {
      return Icons.edit_outlined;
    } else
      return Icons.close;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
              border: Border.all(
                width: 2.0,
                color: GeneralStyle.getDarkGray(),
              ),
              color: Colors.white,
              boxShadow: [ContainerStyles.sameShaddow(true)],
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Icon(
            getIcon(),
            color: GeneralStyle.getDarkGray(),
          ),
        ),
        onTap: () {
          changeState();
        },
      ),
    );
  }
}
