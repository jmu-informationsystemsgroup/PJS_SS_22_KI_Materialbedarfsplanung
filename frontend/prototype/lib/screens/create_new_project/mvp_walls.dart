import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/custom_container_border.dart';
import 'package:prototype/components/input_field.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';

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
  List<Wall> safeList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    safeList = widget.editWalls;
    setUpWidgetMap();
    getWallsVisability();
  }

  setUpWidgetMap() {
    widget.editWalls.forEach((element) {
      setState(() {
        walls[element.id] = newWall(element.id);
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

  switchVisablity() {
    if (addVisabilty) {
      return false;
    } else {
      return true;
    }
  }

  safeWall(Wall wall) {
    if (wall.height != 0.0 && wall.width != 0.0) {
      safeList.add(wall);
    }
    safeList.removeWhere(
        (element) => (element.width == 0.0 || element.height == 0.0));

    widget.outcomeWalls(safeList);

    //test
    print(
        "-------------------------> current wall: ${wall.id} safeListLength ${safeList.length}");
    safeList.forEach((element) {
      print(
          "------------------------->id: ${element.id} width: ${element.width} height: ${element.height}");
    });
  }

  removeWall(int id) {
    safeList.removeWhere((element) => element.id == id);
  }

  Widget newWall(int widgetId) {
    Wall newWall = Wall();
    newWall.id = widgetId;

    Flex container = Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
            child: Text(
          "Wand ${widgetId}",
          style: ContainerStyles.getTextStyle(),
        )),
        Expanded(
          flex: 2,
          child: InputField(
              inputType: TextInputType.number,
              disableMargin: true,
              saveTo: (text) => {
                    if (text == "")
                      {newWall.height = 0.0}
                    else
                      {
                        newWall.width = double.parse(text),
                      },
                    safeWall(newWall),
                    safeWall(newWall),
                  },
              labelText: "Breite"),
        ),
        Expanded(
          flex: 2,
          child: InputField(
              inputType: TextInputType.number,
              disableMargin: true,
              saveTo: (text) => {
                    if (text == "")
                      {newWall.height = 0.0}
                    else
                      {
                        newWall.height = double.parse(text),
                      },
                    safeWall(newWall),
                  },
              labelText: "Höhe"),
        ),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.red),
            onPressed: () {
              setState(
                () {
                  walls.removeWhere((key, value) => key == widgetId);
                  getWallsVisability();
                },
              );
              removeWall(widgetId);
            },
            child: Icon(Icons.delete),
          ),
        ),
      ],
    );
    return container;
  }

  int i = 0;
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
                        walls[i] = newWall(i);
                        i += 1;
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
                  walls[i] = newWall(i);
                  i += 1;
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
