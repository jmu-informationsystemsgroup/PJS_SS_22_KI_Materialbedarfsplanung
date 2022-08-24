import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/styles/container.dart';
import 'package:prototype/screens/load_project/_main_view.dart';

import 'gallery.dart';

class ProjectList extends StatelessWidget {
  List<dynamic> projects;
  String status;
  final Function() listHasChanged;

  ProjectList(this.projects, this.listHasChanged, [this.status = "active"]);

  Widget renderArchiveButton(int id) {
    if (status == "inActive") {
      return ElevatedButton(
        onPressed: () {
          DataBase.activateProject(id);
          listHasChanged();
        },
        child: const Icon(Icons.settings_backup_restore),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          DataBase.archieveProject(id);
          listHasChanged();
        },
        child: const Icon(Icons.archive),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 25),
                    decoration: ContainerStyles.getColoredBoxDecoration(),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                          child: Gallery(element["id"].toString(), 2),
                          width: 150,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Name: " + element["projectName"],
                                  style: ContainerStyles.getTextStyle()),
                              Text("Auftraggeber: " + element["client"],
                                  style: ContainerStyles.getTextStyle()),
                              //  Text("Fälligkeitsdatum: 15.05.2022"),
                              Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(5.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        DataBase.deleteProject(element["id"]);
                                        listHasChanged();
                                      },
                                      child: Icon(Icons.delete),
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.red),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(5.0),
                                    child: renderArchiveButton(element["id"]),
                                  ),
                                ],
                              )
                            ])
                      ],
                    ),
                  )),
            ),
          )
          .toList(),
    );
  }
}
