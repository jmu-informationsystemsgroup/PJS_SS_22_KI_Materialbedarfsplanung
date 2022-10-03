import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/custom_container_border.dart';
import 'package:prototype/components/input_field.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';
import 'package:prototype/styles/general.dart';

import 'button_row_multiple_icons.dart';
import '../styles/container.dart';

class InputWalls extends StatefulWidget {
  Function(List<Wall>) updateValues;
  List<Wall> input;
  InputWalls({required this.updateValues, this.input = const []});

  @override
  _InputWalls createState() {
    return _InputWalls();
  }
}

class _InputWalls extends State<InputWalls> {
  final TextEditingController nameController = TextEditingController();
  bool addVisabilty = false;

  /// Widgetliste sorgt dafür dass die Eingabefelder für neue Wände angezeigt werden
  Map<int, Widget> walls = {};

  /// Übergabeliste, enthält die Daten die später gespeichert werden sollen
  Map<int, Wall> safeList = {};
  int startId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.input.isNotEmpty) {
      startId = widget.input.last.id;

      setUpWidgetMap();
    }

    getWallsVisability();
  }

  setUpWidgetMap() {
    for (Wall element in widget.input) {
      setState(() {
        safeList[element.id] = element;
        walls[element.id] = newWall(widgetId: element.id, wall: element);
      });
    }
  }

  /// sorgt dafür, dass wenn alle Wände aus der Liste gelöscht werden, stattdessen wieder der
  /// "Wand hunzufügen"-Button erscheint
  getWallsVisability() {
    if (walls.isEmpty) {
      setState(() {
        addVisabilty = false;
      });
    } else {
      setState(() {
        addVisabilty = true;
      });
    }
  }

  bool switchVisablity() {
    if (addVisabilty) {
      return false;
    } else {
      return true;
    }
  }

  safeWall(Wall wall) {
    if (wall.height != 0.0 && wall.width != 0.0) {
      setState(() {
        safeList[wall.id] = wall;
      });
    }
    setState(() {
      safeList.removeWhere(
          (key, element) => (element.width == 0.0 || element.height == 0.0));
    });

    widget.updateValues(safeList.values.toList());

    //test
    print(
        "-------------------------> current wall: ${wall.id} safeListLength ${safeList.length}");
    safeList.values.toList().forEach((element) {
      print(
          "------------------------->id: ${element.id} width:  ${wall.width} sf ${element.width} height:  ${wall.height} sf ${element.height}");
    });
  }

  /// entfernt die Wand wieder aus der Übergabeliste
  removeWall(int id) {
    setState(() {
      safeList.removeWhere((key, element) => element.id == id);
    });
    widget.updateValues(safeList.values.toList());
  }

  /// sorgt dafür, dass das Feld anstatt mit "0.0" vorausgefüllt wird, einfach nichts im Feld drinsteht
  /// die 0.0 entsteht dadurch, dass 0.0 das Defaultmaß einer neuen Wand ist
  String setUpValue(double value) {
    if (value == 0.0) {
      return "";
    } else {
      return value.toString();
    }
  }

  Widget newWall({
    required int widgetId,
    required Wall wall,
  }) {
    wall.id = widgetId;

    Container container = Container();

    if (wall.display) {
      container = Container(
        margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: InputField(
                  value: wall.name,
                  disableMargin: true,
                  saveTo: (text) {
                    wall.name = text;
                    safeWall(wall);
                  },
                  labelText: ""),
            ),
            Expanded(
              flex: 3,
              child: InputField(
                  value: setUpValue(wall.width),
                  inputType: TextInputType.number,
                  disableMargin: true,
                  saveTo: (text) {
                    if (text == "") {
                      wall.width = 0.0;
                    } else {
                      wall.width = double.parse(text);
                    }
                    safeWall(wall);
                  },
                  labelText: ""),
            ),
            Expanded(
              flex: 3,
              child: InputField(
                  value: setUpValue(wall.height),
                  inputType: TextInputType.number,
                  disableMargin: true,
                  saveTo: (text) {
                    if (text == "") {
                      wall.height = 0.0;
                    } else {
                      wall.height = double.parse(text);
                    }
                    safeWall(wall);
                  },
                  labelText: ""),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(
                    () {
                      wall.display = false;
                      getWallsVisability();
                    },
                  );
                  setUpWidgetMap();
                  removeWall(widgetId);
                },
                child: Center(
                  child: Icon(
                    Icons.delete,
                    color: GeneralStyle.getDarkGray(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Visibility(
      child: container,
      visible: wall.display,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Visibility(
          visible: addVisabilty,
          child: Column(
            children: [
              Flex(direction: Axis.horizontal, children: [
                Expanded(child: Text("Typ"), flex: 3),
                Expanded(
                    child: Wrap(
                      children: [
                        Icon(Icons.sync_alt_outlined),
                        Text("Breite"),
                      ],
                    ),
                    flex: 3),
                Expanded(
                    child: Wrap(
                      children: [
                        Icon(Icons.swap_vert_outlined),
                        Text("Höhe"),
                      ],
                    ),
                    flex: 3),
                Expanded(child: Container(), flex: 1),
              ]),
              Column(
                children: walls.values.toList(),
              ),
              CustomButtonRow(
                  children: [Icon(Icons.add)],
                  onPressed: () {
                    setState(() {
                      walls[startId] = newWall(widgetId: startId, wall: Wall());
                      startId += 1;
                    });
                  }),
            ],
          ),
        ),
        Visibility(
          visible: switchVisablity(),
          child: ElevatedButton(
            onPressed: () {
              setState(
                () {
                  walls[startId] = newWall(widgetId: startId, wall: Wall());
                  startId += 1;
                  getWallsVisability();
                },
              );
            },
            child: const Text("Fläche manuell eingeben"),
          ),
        ),
      ],
    );
  }
}
