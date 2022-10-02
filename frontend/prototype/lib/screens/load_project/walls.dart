import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/button_edit.dart';
import 'package:prototype/components/icon_and_text.dart';
import 'package:prototype/components/input_walls.dart';

import '../../components/custom_container_border.dart';
import '../../styles/general.dart';

class Walls extends StatefulWidget {
  Content content;
  Walls({required this.content});

  @override
  State<StatefulWidget> createState() {
    return _WallState();
  }
}

class _WallState extends State<Walls> {
  List<Widget> wallStrings = [];
  bool textVisiblity = false;
  List<Wall> walls = [];

  @override
  void initState() {
    super.initState();
    setUpWalls();
  }

  setUpWalls() {
    List<Widget> initList = [];
    DataBase.getWalls(widget.content.id).then((List<Wall> inputWalls) {
      if (inputWalls != null) {
        setState(() {
          walls = inputWalls;
        });
        if (inputWalls.isNotEmpty) {
          textVisiblity = true;
        }
        inputWalls.forEach(
          (element) {
            String name = "";
            if (element.name == "") {
              name = "Wand ${element.id}";
            } else {
              name = element.name;
            }
            Widget widget = Text(
                "$name: ${element.width}m Breite, ${element.height}m Höhe");

            initList.add(widget);
          },
        );
        setState(() {
          wallStrings.addAll(initList);
        });
      }
    });
  }

  changeBool(bool value) {
    if (value) {
      setState(() {
        textVisiblity = !value;
      });
    } else {
      setState(() {
        textVisiblity = value;
      });
    }
  }

  Widget displayText() {
    Column column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Zusätzliche Flächen",
            style: TextStyle(
              color: GeneralStyle.getLightGray(),
              fontStyle: FontStyle.italic,
            )),
      ],
    );
    column.children.addAll(wallStrings);

    return column;
  }

  Widget addContent() {
    if (!textVisiblity) {
      return Column(
        children: [
          InputWalls(
            outcomeWalls: (outcomeWalls) {
              setState(() {
                walls = outcomeWalls;
              });
              // TODO: Database
            },
            editWalls: walls,
          ),
          ElevatedButton(
              onPressed: () async {
                await DataBase.updateWalls(walls, widget.content.id);
                setState(() {
                  textVisiblity = true;
                });
              },
              child: Icon(Icons.save))
        ],
      );
    } else {
      return displayText();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("textvisibility $textVisiblity !textvisibility ${!textVisiblity}");
    print("object ${walls.length}");

    if (walls.isEmpty) {
      return addContent();
    } else {
      return CustomContainerBorder(
        color: GeneralStyle.getLightGray(),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: ButtonEdit(
                textVisiblity: textVisiblity,
                onClick: () {
                  changeBool(textVisiblity);
                },
              ),
            ),
            addContent(),
          ],
        ),
      );
    }
  }
}
