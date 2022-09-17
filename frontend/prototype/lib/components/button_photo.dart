import 'package:flutter/material.dart';

import '../styles/general.dart';
import 'button_row_multiple_icons.dart';

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
