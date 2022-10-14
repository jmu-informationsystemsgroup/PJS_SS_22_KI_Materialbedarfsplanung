import 'package:flutter/material.dart';

import '../../styles/general.dart';

class ButtonFLash extends StatelessWidget {
  bool flashOn = false;
  Function() changeFlashMode;
  ButtonFLash({required this.flashOn, required this.changeFlashMode});

  /// bestimmt welches Symbol an der Stelle des Blitze-Buttons angezeigt wird
  IconData getIcon() {
    if (!flashOn) {
      return Icons.flash_off;
    } else {
      return Icons.flash_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
              border: Border.all(
                width: 2.0,
                color: GeneralStyle.getLightGray(),
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Icon(
            getIcon(),
            color: GeneralStyle.getLightGray(),
          ),
        ),
        onTap: () {
          changeFlashMode();
        },
      ),
    );
  }
}
