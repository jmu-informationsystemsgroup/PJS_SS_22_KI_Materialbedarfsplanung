import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/components/custom_container_border.dart';
import 'package:prototype/components/icon_and_text.dart';
import 'package:prototype/styles/container.dart';
import 'package:prototype/screens/load_project/_main_view.dart';
import 'package:prototype/styles/general.dart';
import 'package:relative_scale/relative_scale.dart';
import '../../backend/helper_objects.dart';
import '../../components/gallery.dart';

class ProjectList extends StatefulWidget {
  List<Content> projects;
  String status;
  final Function() listHasChanged;
  List<int> previousColors = [99, 99];

  ProjectList(this.projects, this.listHasChanged, [this.status = "active"]);

  @override
  State<StatefulWidget> createState() {
    return _StateProjectList();
  }
}

class _StateProjectList extends State<ProjectList> {
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

/*
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
  */

  openImagePicker(Content element) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image

    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
    );
    var outCome = await DataBase.saveProfileImage(image!, element.id);
    setState(() {
      element.profileImage = image;
    });
  }

  getProfile(Content element) {
    if (element.profileImage == null) {
      return Icon(
        Icons.cottage_outlined,
        color: Colors.black,
        size: 40,
      );
    } else {
      return Stack(
        children: [
          Center(
            child: FullScreenWidget(
                child: Image.file(File(element.profileImage!.path))),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: GestureDetector(
              child: Icon(Icons.delete, color: GeneralStyle.getLightGray()),
              onTap: () async {
                var outCome = await DataBase.deleteProfileImage(element.id);
                setState(() {
                  element.profileImage = null;
                });
              },
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("meldung");

    return Column(
      children: widget.projects
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
                        child: GestureDetector(
                          onTap: () {
                            openImagePicker(element);
                          },
                          child: Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 1 / 1,
                                child: CustomContainerBorder(
                                  color: GeneralStyle.getUglyGreen(),
                                  //  padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                  child: getProfile(element),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 15, 15, 0),
                                  child: Icon(Icons.add_a_photo,
                                      color: GeneralStyle.getLightGray()),
                                ),
                              ),
                            ],
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
