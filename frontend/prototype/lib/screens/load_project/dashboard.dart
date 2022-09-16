import 'package:flutter/material.dart';
import 'package:prototype/components/button_row_multiple_icons.dart';
import 'package:prototype/components/custom_container_white.dart';
import 'package:prototype/components/icon_and_text.dart';
import 'package:prototype/styles/general.dart';

import '../../backend/helper_objects.dart';
import '../../backend/value_calculator.dart';

class Dashboard extends StatefulWidget {
  List galleryImages;
  Content content;
  CalculatorOutcome outcome;
  int state;
  Function() updateImages;
  bool recalculate;
  Dashboard(
      {required this.galleryImages,
      required this.updateImages,
      required this.content,
      required this.state,
      required this.recalculate,
      required this.outcome});
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  Future<void> _showInformationDialog() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: IconAndText(
            icon: Icons.info,
            text: "Info",
          ),
          content: Text(
              'Bei den ermittelten Werten handelt es sich um den Materialbedarf' +
                  ' für "SpachtelBar Classic" und andere Spachelmassen' +
                  ' unterliegen anderen Materialbedarfsmengen'),
          actions: <Widget>[
            TextButton(
              child: const Text('Verstanden!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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

  Widget squareAiValue({required IconData icon, required String underLine}) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: CustomContainerBorder(
        color: GeneralStyle.getUglyGreen(),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  _showInformationDialog();
                },
                child: Icon(
                  Icons.info,
                  color: GeneralStyle.getLightGray(),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon),
                Text(
                  underLine,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget displayData() {
    if (widget.galleryImages.isEmpty) {
      return CustomContainerBorder(
        child: Column(
          children: [
            Text("Mache Bilder um einen KI Wert ermitteln zu können"),
            Icon(Icons.add_a_photo_outlined),
          ],
        ),
      );
    } else if (widget.recalculate) {
      return Text("Status: $widget.state%");
    } else if (widget.outcome.aiOutcome == 0.0) {
      return CustomContainerBorder(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Um den Bedarf zu ermitteln synchronisiere deine Bilddaten"),
            CustomButtonRow(children: [
              Icon(
                Icons.sync,
                color: GeneralStyle.getUglyGreen(),
              ),
              Text(
                "Bilder synchronisieren",
                style: TextStyle(color: GeneralStyle.getUglyGreen()),
              ),
            ], onPressed: widget.updateImages),
          ],
        ),
      );
    } else if (widget.outcome.exception) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rowTwo(),
          CustomContainerBorder(
            color: Colors.orange,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: 2,
                  child: Icon(
                    Icons.warning_amber,
                    color: Colors.orange,
                    size: 50,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(widget.outcome.exceptionText),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return rowTwo();
    }
  }

  Widget rowOne() {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: square(
              icon: Icons.window,
              underLine: "${widget.galleryImages.length} Wände"),
        ),
        Expanded(
          child: square(
              icon: Icons.verified_outlined,
              underLine: "Qualität ${widget.content.material}"),
        ),
      ],
    );
  }

  Widget rowTwo() {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: squareAiValue(
              icon: Icons.colorize,
              underLine:
                  "${widget.outcome.aiOutcome.toStringAsFixed(2)} kg Spachtelmasse"),
        ),
        Expanded(
          child: square(
              icon: Icons.euro,
              underLine:
                  "${widget.outcome.totalAiPrice.toStringAsFixed(2)} € Materialkosten"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        rowOne(),
        displayData(),
      ],
    );
  }
}
