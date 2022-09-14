import 'package:flutter/material.dart';
import 'package:prototype/components/custom_container_white.dart';
import 'package:prototype/styles/general.dart';

import '../../backend/helper_objects.dart';

class Dashboard extends StatelessWidget {
  List galleryImages;
  Content content;
  double aiValue;
  double price;
  Dashboard(
      {required this.galleryImages,
      required this.content,
      required this.aiValue,
      required this.price});
  Widget square({required IconData icon, required String underLine}) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: CustomContainerBorder(
        color: GeneralStyle.getUglyGreen(),
        child: Column(
          //  crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            Text(
              underLine,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget rowOne() {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: square(
              icon: Icons.window, underLine: "${galleryImages.length} Wände"),
        ),
        Expanded(
          child: square(
              icon: Icons.verified_outlined,
              underLine: "Qualität ${content.material}"),
        ),
      ],
    );
  }

  Widget rowTwo() {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: square(
              icon: Icons.colorize,
              underLine: "${aiValue.toStringAsFixed(2)} kg Spachtelmasse"),
        ),
        Expanded(
          child: square(
              icon: Icons.euro,
              underLine: "${price.toStringAsFixed(2)} € Materialkosten"),
        ),
      ],
    );
  }

  Widget rowThree() {
    return CustomContainerBorder(
      color: GeneralStyle.getLightGray(),
      child: Column(
        //  crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Kommentar:",
            style: TextStyle(
              color: GeneralStyle.getLightGray(),
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(content.comment),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        rowOne(),
        rowTwo(),
        rowThree(),
      ],
    );
  }
}
