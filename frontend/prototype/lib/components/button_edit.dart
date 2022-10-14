import 'package:flutter/material.dart';

import '../styles/container.dart';
import '../styles/general.dart';

/// runder Bearbeiten-Button, der an mehreren Stellen in der App vorkommt
/// Besonderheiten: wechselt das Icon, wenn angklickt, Form und Farbe
class ButtonEdit extends StatelessWidget {
  bool textVisiblity;
  Function() onClick;
  ButtonEdit({required this.textVisiblity, required this.onClick});

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
          onClick();
        },
      ),
    );
  }
}
