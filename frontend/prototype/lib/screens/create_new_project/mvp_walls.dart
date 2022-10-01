import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/custom_container_border.dart';
import 'package:prototype/components/input_field.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';
import 'package:prototype/styles/general.dart';

import '../../components/button_row_multiple_icons.dart';
import '../../styles/container.dart';

class MVPWalls extends StatefulWidget {
  Function(List<Wall>) outcomeWalls;
  List<Wall> editWalls;
  MVPWalls({required this.outcomeWalls, this.editWalls = const []});

  @override
  _MVPWalls createState() {
    return _MVPWalls();
  }
}

class _MVPWalls extends State<MVPWalls> {
  final TextEditingController nameController = TextEditingController();
  bool addVisabilty = false;
  Map<int, Widget> walls = {};
  Map<int, Wall> safeList = {};
  int startId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.editWalls.isNotEmpty) {
      startId = widget.editWalls.last.id;

      setUpWidgetMap();
    }

    getWallsVisability();
  }

  setUpWidgetMap() {
    widget.editWalls.forEach((element) {
      setState(() {
        safeList[element.id] = element;
        walls[element.id] = newWall(
          widgetId: element.id,
          width: element.width,
          height: element.height,
          name: element.name,
        );
      });
    });
  }

  getWallsVisability() {
    if (walls.length == 0) {
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
    safeList.removeWhere(
        (key, element) => (element.width == 0.0 || element.height == 0.0));

    widget.outcomeWalls(safeList.values.toList());

    //test
    print(
        "-------------------------> current wall: ${wall.id} safeListLength ${safeList.length}");
    safeList.values.toList().forEach((element) {
      print(
          "------------------------->id: ${element.id} width:  ${wall.width} sf ${element.width} height:  ${wall.height} sf ${element.height}");
    });
  }

  removeWall(int id) {
    safeList.removeWhere((key, element) => element.id == id);
  }

  String setUpValue(double value) {
    if (value == 0.0) {
      return "";
    } else {
      return value.toString();
    }
  }

  Widget newWall({
    required int widgetId,
    double width = 0.0,
    double height = 0.0,
    String name = "",
  }) {
    Wall wall = Wall();
    wall.id = widgetId;

    Container container = Container(
      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: InputField(
                value: name,
                disableMargin: true,
                saveTo: (text) {
                  wall.name = text;
                  safeWall(wall);
                },
                labelText: "Name"),
          ),
          Expanded(
            flex: 3,
            child: InputField(
                value: setUpValue(width),
                inputType: TextInputType.number,
                disableMargin: true,
                icon: Icons.sync_alt_outlined,
                saveTo: (text) {
                  if (text == "") {
                    wall.width = 0.0;
                  } else {
                    wall.width = double.parse(text);
                  }
                  safeWall(wall);
                },
                labelText: "Breite"),
          ),
          Expanded(
            flex: 3,
            child: InputField(
                icon: Icons.swap_vert_outlined,
                value: setUpValue(height),
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
                labelText: "Höhe"),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(
                  () {
                    walls.removeWhere((key, value) => key == widgetId);
                    getWallsVisability();
                  },
                );
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

    return container;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Visibility(
          visible: addVisabilty,
          child: CustomContainerBorder(
            child: Column(
              children: [
                Column(
                  children: walls.values.toList(),
                ),
                CustomButtonRow(
                    children: [Icon(Icons.add)],
                    onPressed: () {
                      setState(() {
                        walls[startId] = newWall(widgetId: startId);
                        startId += 1;
                      });
                    }),
              ],
            ),
          ),
        ),
        Visibility(
          visible: switchVisablity(),
          child: ElevatedButton(
            onPressed: () {
              setState(
                () {
                  walls[startId] = newWall(widgetId: startId);
                  startId += 1;
                  getWallsVisability();
                },
              );
            },
            child: const Text("Wand hinzufügen"),
          ),
        ),
      ],
    );
  }
}
