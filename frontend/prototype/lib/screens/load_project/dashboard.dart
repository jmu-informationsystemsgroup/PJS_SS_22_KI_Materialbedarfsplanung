import 'package:flutter/material.dart';
import 'package:prototype/components/button_row_multiple_icons.dart';
import 'package:prototype/components/custom_container_border.dart';
import 'package:prototype/components/gallery.dart';
import 'package:prototype/components/icon_and_text.dart';
import 'package:prototype/styles/general.dart';

import '../../backend/helper_objects.dart';
import '../../backend/value_calculator.dart';

class Dashboard extends StatefulWidget {
  List<CustomCameraImage> galleryImages;
  List<CustomCameraImage> imagesToDelete;
  Content content;
  CalculatorOutcome outcome;
  int state;
  List<Wall> walls;
  Function() updateImages;
  Function() addPhoto;
  Function(CustomCameraImage) deleteFunction;
  bool recalculate;
  Dashboard(
      {required this.galleryImages,
      required this.imagesToDelete,
      required this.updateImages,
      required this.content,
      required this.state,
      required this.deleteFunction,
      required this.addPhoto,
      required this.walls,
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
              child: Text(
                'Verstanden!',
                style: TextStyle(
                  color: GeneralStyle.getUglyGreen(),
                ),
              ),
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

  Widget squareAiValue(
      {required IconData icon,
      required String underLineProduct,
      required String underLinePrice}) {
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
                  underLineProduct,
                  textAlign: TextAlign.center,
                ),
                Text(
                  underLinePrice,
                  textAlign: TextAlign.center,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget displayData() {
    if (widget.galleryImages.isEmpty && widget.walls.isEmpty) {
      return CustomContainerBorder(
        child: Column(
          children: [
            Text(
              "Mache Fotos um einen KI Wert ermitteln zu können",
              textAlign: TextAlign.center,
            ),
            Icon(Icons.add_a_photo_outlined),
          ],
        ),
      );
    } else if (widget.recalculate) {
      return CustomContainerBorder(
        child: Center(child: Text("Status: ${widget.state}%")),
      );
    } else if (widget.outcome.material == 0.0 &&
        widget.galleryImages.length != widget.imagesToDelete.length) {
      return CustomContainerBorder(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Jetzt Bedarf ermitteln? ",
                    style: TextStyle(color: Colors.black),
                  ),
                  WidgetSpan(
                    child: Icon(Icons.format_color_fill),
                  ),
                ],
              ),
            ),
            CustomButtonRow(children: [
              Icon(
                Icons.sync,
              ),
            ], onPressed: widget.updateImages),
          ],
        ),
      );
    } else {
      return displayRowTwo();
    }
  }

  Widget displayRowTwo() {
    if (widget.outcome.exception) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rowTwo(),
          CustomContainerBorder(
            color: Colors.orange,
            child: Column(
              children: [
                Flex(
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
                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Gallery(
                        pictures: widget.imagesToDelete,
                        deleteFunction: (element) {
                          widget.deleteFunction(element);
                        },
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: CustomButtonRow(
                          children: [Icon(Icons.add_a_photo_outlined)],
                          onPressed: widget.addPhoto,
                        )),
                  ],
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
              underLine:
                  "${widget.galleryImages.length + widget.walls.length} Wände und Decken"),
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
              icon: Icons.format_color_fill,
              underLineProduct:
                  "${widget.outcome.material.toStringAsFixed(2)} kg Spachtelmasse",
              underLinePrice:
                  "(${widget.outcome.priceMaterial.toStringAsFixed(2)} €)"),
        ),
        Expanded(
          child: squareAiValue(
              icon: Icons.format_paint_outlined,
              underLineProduct:
                  "${widget.outcome.edges.toStringAsFixed(2)} m Fugenstreifen",
              underLinePrice:
                  "(${widget.outcome.priceEdges.toStringAsFixed(2)} €)"),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print("---------------------------------->dashboard wurde aufgerufen");
    return Column(
      children: [
        rowOne(),
        displayData(),
      ],
    );
  }
}
