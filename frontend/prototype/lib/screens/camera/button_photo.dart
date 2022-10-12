import 'package:flutter/material.dart';

import '../../styles/general.dart';
import '../../components/button_row_multiple_icons.dart';

/// gibt den Button zurück, über den in die Kameraansicht gewechselt wird
class ButtonPhoto extends StatelessWidget {
  Function() addPhoto;
  ButtonPhoto({required this.addPhoto});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(child: Container()),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: CustomButtonRow(
              children: [
                Icon(
                  Icons.add_a_photo_outlined,
                ),
              ],
              onPressed: () {
                /// die folgende If condition ist frei nach https://flutterigniter.com/dismiss-keyboard-form-lose-focus/ und verhindert,
                /// dass von der Tastatur ein Bug entsteht, wenn man die Kamera öffnet
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                addPhoto();
              },
            ),
          ),
        ),
        Expanded(child: Container())
      ],
    );
  }
}
