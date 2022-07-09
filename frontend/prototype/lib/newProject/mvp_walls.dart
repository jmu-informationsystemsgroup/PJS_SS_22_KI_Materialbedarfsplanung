import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/newProject/mainView.dart';

import '../styles/container.dart';

class MVPWalls extends StatefulWidget {
  @override
  _MVPWalls createState() {
    return _MVPWalls();
  }
}

class _MVPWalls extends State<MVPWalls> {
  final TextEditingController nameController = TextEditingController();

  List<Widget> walls = [];

  int i = 1;

  Widget newWall(int i) {
    Wall newWall = new Wall();
    NewProject.cash.squareMeters.add(new Wall());
    print(NewProject.cash.squareMeters);

    Container container = Container(
      margin: const EdgeInsets.fromLTRB(15, 3, 15, 7),
      decoration: ContainerStyles.getBoxDecoration(),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 25),
      child: Wrap(
        spacing: 20, // to apply margin in the main axis of the wrap
        runSpacing: 20, // to apply margin in the cross axis of the wrap
        children: <Widget>[
          Text(
            "Wand $i",
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
                          walls.remove(walls[i - 1]);
                          NewProject.cash.squareMeters[i - 1] = Wall();
                        },
                      );
                    },
                    child: const Text("Löschen"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(
                        () {
                          NewProject.cash.squareMeters[i - 1] = newWall;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Column(
          children: walls,
        ),
        ElevatedButton(
          onPressed: () {
            setState(
              () {
                walls.add(
                  newWall(i),
                );
                i += 1;
              },
            );

            print(walls.toString());
          },
          child: const Text("Wand hinzufügen"),
        )
      ],
    );
  }
}
