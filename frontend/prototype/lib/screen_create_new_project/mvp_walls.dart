import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/screen_create_new_project/mainView.dart';

import '../styles/container.dart';

class MVPWalls extends StatefulWidget {
  @override
  _MVPWalls createState() {
    return _MVPWalls();
  }
}

class _MVPWalls extends State<MVPWalls> {
  final TextEditingController nameController = TextEditingController();

  Map<int, Widget> walls = {};

  Widget newWall(int i) {
    print("wallleeeeeeeeeeeeeeeeeeeeee" + walls.toString());
    print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii $i");
    Wall newWall = Wall();
    int wallTitle = i + 1;

    Container container = Container(
      margin: const EdgeInsets.fromLTRB(15, 3, 15, 7),
      decoration: ContainerStyles.getBoxDecoration(),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 25),
      child: Wrap(
        spacing: 20, // to apply margin in the main axis of the wrap
        runSpacing: 20, // to apply margin in the cross axis of the wrap
        children: <Widget>[
          Text(
            "Wand $wallTitle",
            style: ContainerStyles.getTextStyle(),
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(
                      () {
                        newWall.width = double.parse(value);
                      },
                    );
                  },
                  decoration: ContainerStyles.getInputStyle("Breite"),
                ),
              ),
              SizedBox(width: 10),
              Flexible(
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(
                      () {
                        newWall.height = double.parse(value);
                      },
                    );
                    print(newWall.toString());
                  },
                  decoration: ContainerStyles.getInputStyle("Höhe"),
                ),
              ),
              Column(
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      setState(
                        () {
                          walls.removeWhere((key, value) => key == i);
                          NewProject.cash.squareMeters
                              .removeWhere((element) => element.key == i);
                        },
                      );
                    },
                    child: const Text("Löschen"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(
                        () {
                          newWall.key = i;
                          NewProject.cash.squareMeters.add(newWall);
                        },
                      );
                    },
                    child: const Text("Speichern"),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
    return container;
  }

  int i = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            setState(
              () {
                walls[i] = newWall(i);
                i += 1;
              },
            );
          },
          child: const Text("Wand hinzufügen"),
        ),
        Column(
          children: walls.values.toList(),
        ),
      ],
    );
  }
}
