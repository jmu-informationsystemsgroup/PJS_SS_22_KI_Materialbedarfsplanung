import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:prototype/localDrive/content.dart';
import 'package:prototype/newProject/mainView.dart';

import '../styles/container.dart';

class MVP extends StatefulWidget {
  @override
  _MVP createState() {
    return _MVP();
  }
}

class _MVP extends State<MVP> {
  final TextEditingController nameController = TextEditingController();

  List<Widget> walls = [];

  int i = 1;

  Widget newWall(int i) {
    Map<String, double> newWallList = {'width': 0.0, 'height': 0.0};

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
                  onChanged: (value) {
                    setState(
                      () {
                        newWallList['width'] = double.parse(value);
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
                  onChanged: (value) {
                    setState(
                      () {
                        newWallList['height'] = double.parse(value);
                        print(newWallList);
                      },
                    );
                    print(newWallList.toString());
                  },
                  decoration: ContainerStyles.getInputStyle("Höhe"),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(
                    () {
                      NewProject.cash.squareMeters.add(newWallList);
                      print(newWallList.toString());
                    },
                  );
                },
                child: Text("Fertig"),
              ),
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
          child: Text("Wand hinzufügen"),
        )
      ],
    );
  }
}
