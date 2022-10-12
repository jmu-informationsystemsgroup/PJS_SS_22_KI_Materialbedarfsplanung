import 'package:flutter/material.dart';
import 'package:prototype/components/button_row_multiple_icons.dart';
import 'package:prototype/components/custom_container_border.dart';
import 'package:prototype/components/gallery.dart';
import 'package:prototype/components/icon_and_text.dart';
import 'package:prototype/styles/general.dart';

import '../../backend/helper_objects.dart';
import '../../backend/value_calculator.dart';

/// erzeugt die vier Informationskacheln im oberen Bereich des Dashboards
class Dashboard extends StatefulWidget {
  List<CustomCameraImage> galleryImages;
  List<CustomCameraImage> imagesToDelete;
  Content content;
  CalculatorOutcome outcome;
  int state;
  List<Wall> walls;

  /// ändert die Liste der Fotos, wenn von der KI als fehlerhaft aufgedeckte Fotos
  /// gelöscht werden
  Function() updateImages;

  /// ruft die Kamera auf, sollte sich der Nutzer entscheiden das fehlerhafte Foto durch
  /// ein neues zu ersetzen
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
  /// gibt den Dialog über die Spachteprofiprodukte zurück
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
                  color: GeneralStyle.getGreen(),
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

  /// genereirt eine Kachel, Übergabewerte sind Icon und der dazugehörige Text
  Widget square({required IconData icon, required String underLine}) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: CustomContainerBorder(
        color: GeneralStyle.getGreen(),
        child: Center(
          child: SingleChildScrollView(
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
        ),
      ),
    );
  }

  /// generiert eine Kachel mit den Ki ermittelten Werten. Der Unterschied besteht darin, dass die KI-Kacheln mehr als
  /// einen Text-Wert enthalten und zusätzlich noch ein Informationsicon über das ein Dialog geöffnet werden kann
  Widget squareAiValue(
      {required IconData icon,
      required String underLineProduct,
      required String underLinePrice}) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: CustomContainerBorder(
        color: GeneralStyle.getGreen(),
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
            Center(
              child: SingleChildScrollView(
                child: Column(
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// entscheidet, was im unteren Bereich des Dashboards angezeigt wird (5 Zustände):
  /// 1. es sind keine Fotos vorhanden,
  /// 2. Fotos vorhanden aber nicht synchronisiert,
  /// 3. Fotos werden synchrnisert
  /// 4. Fotos vorhanden und synchronisiert aber fehlerhaft
  /// 5. Fotos vorhanden und synchronisiert und fehlerfrei
  Widget displayData() {
    // 1. es sind keine Fotos vorhanden
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
    }
    // 3. Fotos werden synchronisert
    else if (widget.recalculate) {
      return CustomContainerBorder(
        child: Center(child: Text("Status: ${widget.state}%")),
      );
    }
    // 2. Fotos vorhanden aber nicht synchronisiert
    else if (widget.outcome.material == 0.0 &&
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
    }
    // 4. Fotos vorhanden und synchronisiert aber fehlerhaft und 5. Fotos vorhanden und synchronisiert und fehlerfrei
    else {
      return displayRowTwo();
    }
  }

  /// entscheided ob nur die beiden Kacheln angezeigt werden oder ob die beiden Kacheln zusammen mit dem Dialog
  /// für fehlerhafte Bilder angezeigt werden
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

  /// gibt die oberen beiden Kacheln des Dashboards zurück
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

  /// gibt die beiden unteren Kacheln mit den KI ermittelten Werten zurück
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
    return Column(
      children: [
        rowOne(),
        displayData(),
      ],
    );
  }
}
