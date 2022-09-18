import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/components/custom_container_white.dart';
import 'package:prototype/components/icon_and_text.dart';
import 'package:prototype/styles/container.dart';
import 'package:prototype/screens/load_project/_main_view.dart';
import 'package:prototype/styles/general.dart';
import 'package:relative_scale/relative_scale.dart';
import '../../backend/helper_objects.dart';
import '../../components/gallery.dart';

class ProjectList extends StatelessWidget {
  List<Content> projects;
  String status;
  final Function() listHasChanged;
  List<int> previousColors = [99, 99];

  ProjectList(this.projects, this.listHasChanged, [this.status = "active"]);

  informationChecker(
      {required IconData icon, required String text, required value}) {
    if (value == "") {
      return Container();
    } else {
      return IconAndText(
        icon: icon,
        text: text,
        flexLevel: 5,
      );
    }
  }

  randomColorPicker() {
    int randomValue = Random().nextInt(7);
    while (previousColors.last == randomValue ||
        previousColors[previousColors.length - 1] == randomValue) {
      randomValue = Random().nextInt(7);
    }
    previousColors.add(randomValue);
    List<Color> colors = [
      GeneralStyle.getDarkGray(),
      GeneralStyle.getLightGray(),
      GeneralStyle.getUglyGreen(),
      Colors.green[900]!,
      Colors.green[300]!,
      Colors.green,
      Colors.black
    ];
    return colors[randomValue];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("meldung");

    return Column(
      children: projects
          .map(
            (element) => Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProjectView(element)),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: CustomContainerBorder(
                            color: randomColorPicker(),
                            //  padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                            child: Icon(
                              Icons.cottage_outlined,
                              color: randomColorPicker(),
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: ContainerStyles.getMargin(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Text(
                                  element.projectName,
                                  style: TextStyle(
                                      /*
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 5,
                                      decorationColor:
                                          GeneralStyle.getUglyGreen(),
                                          */
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              informationChecker(
                                  icon: Icons.person_pin_circle_outlined,
                                  text: "Kunde: ${element.client}",
                                  value: element.client),
                              informationChecker(
                                  icon: Icons.location_on_outlined,
                                  text: "Ort: ${element.city}",
                                  value: element.city),
                              informationChecker(
                                  icon: Icons.calendar_month_outlined,
                                  text: "Datum: ${element.date}",
                                  value: element.date),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
