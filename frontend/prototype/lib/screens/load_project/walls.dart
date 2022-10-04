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
  List<Wall> walls;
  Function(List<Wall>) updateWalls;
  Walls({
    required this.content,
    required this.walls,
    required this.updateWalls,
  });

  @override
  State<StatefulWidget> createState() {
    return _WallState();
  }
}

class _WallState extends State<Walls> {
  List<Widget> wallStrings = [];
  bool textVisiblity = false;
  bool saveVisibility = false;

  /// Zwei Wall-Listen, falls der Nutzer den Bearbeitungsvorgang abbricht,
  /// die wall-Liste beinhaltet sowohl die ursprünglichen, als auch die hinzugefügten Wände
  /// die wall-Liste wird verworfen, falls der Nutzer den Bearbeitungsvorgang abbricht
  List<Wall> walls = [];

  /// originalWalls die Wände die es bereits vor Klassenaufruf gab
  List<Wall> originalWalls = [];

  @override
  void initState() {
    super.initState();
    if (walls.isEmpty) {
      setUpWalls();
    }
  }

  @override
  void didUpdateWidget(Walls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.walls.toString() != widget.walls.toString() &&
        walls.isEmpty) {
      setUpWalls();
    }
  }

  setUpWalls() {
    setState(() {
      originalWalls = widget.walls;
      walls = originalWalls;
    });

    if (widget.walls.isNotEmpty) {
      textVisiblity = true;
    }
    setState(() {
      wallStrings = setUpStrings(widget.walls);
    });
  }

  List<Widget> setUpStrings(List<Wall> objectWalls) {
    List<Widget> strings = [];
    for (Wall element in objectWalls) {
      String name = "";
      if (element.name == "") {
        name = "Wand ${element.id}";
      } else {
        name = element.name;
      }

      Widget widget = Wrap(
        children: [
          Text(
            "$name: ",
            style: TextStyle(color: Colors.black),
          ),
          Icon(Icons.sync_alt_outlined),
          Text(
            " ${element.width}m ",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            "Breite, ",
            style: TextStyle(
              color: GeneralStyle.getDarkGray(),
              fontStyle: FontStyle.italic,
            ),
          ),
          Icon(Icons.swap_vert_outlined),
          Text(
            " ${element.height}m ",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            "Höhe",
            style: TextStyle(
              color: GeneralStyle.getDarkGray(),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );

      strings.add(widget);
    }
    return strings;
  }

  changeBool(bool value) {
    if (textVisiblity == false) {
      for (Wall element in originalWalls) {
        element.display = true;
      }
      setUpWalls();
    }
    setState(() {
      textVisiblity = !value;
    });
  }

  bool changeBool2(List<Wall> originalWalls) {
    if (originalWalls.isEmpty) {
      return false;
    } else {
      return true;
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

  bool getSaveVisability() {
    if (originalWalls.isNotEmpty || walls.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Widget addContent() {
    if (!textVisiblity) {
      return Column(
        children: [
          InputWalls(
            updateValues: (outcomeWalls) {
              setState(() {
                walls = outcomeWalls;
              });
              // TODO: Database
            },
            input: walls,
          ),
          Visibility(
            visible: getSaveVisability(),
            child: ElevatedButton(
              onPressed: () async {
                bool isFinished =
                    await DataBase.updateWalls(walls, widget.content.id);
                setState(() {
                  wallStrings = setUpStrings(walls);
                  originalWalls = walls;
                  textVisiblity = changeBool2(originalWalls);
                });
                widget.updateWalls(walls);
              },
              child: Icon(Icons.save),
            ),
          ),
        ],
      );
    } else {
      return Container(
        child: displayText(),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainerBorder(
      color: GeneralStyle.getLightGray(),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Visibility(
              visible: getSaveVisability(),
              child: ButtonEdit(
                textVisiblity: textVisiblity,
                onClick: () {
                  changeBool(textVisiblity);
                },
              ),
            ),
          ),
          Center(
            child: addContent(),
          ),
        ],
      ),
    );
  }
}
