import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/components/custom_container_white.dart';
import 'package:prototype/styles/container.dart';
import 'package:prototype/screens/load_project/_main_view.dart';
import 'package:relative_scale/relative_scale.dart';
import '../../backend/helper_objects.dart';
import '../../components/gallery.dart';

class ProjectList extends StatelessWidget {
  List<Content> projects;
  String status;
  final Function() listHasChanged;

  ProjectList(this.projects, this.listHasChanged, [this.status = "active"]);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("meldung");

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
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: CustomContainerWhite(
                          //  padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                          child: Icon(
                            Icons.house,
                            color: Color.fromARGB(75, 0, 0, 0),
                            size: 80,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
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
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Text("Kunde: " + element.client,
                                  style: ContainerStyles.getTextStyle()),
                              Text("Ort: " + element.city,
                                  style: ContainerStyles.getTextStyle()),
                              Text("Datum: " + element.date,
                                  style: ContainerStyles.getTextStyle()),
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
