import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prototype/localDrive/data_base_functions.dart';
import 'package:prototype/styles/container.dart';
import 'package:prototype/projectView/mainView.dart';

import '../projectView/gallery.dart';

class ProjectList extends StatelessWidget {
  List<dynamic> projects;
  String status;
  ProjectList(this.projects, [this.status = "active"]);

  var galleryList = [];

/*
  /// befüllt die Liste "galleryList" mit den Bildern aus dem angegbenen Ordner
  List<dynamic> getSampleImages(String src) {
    FileUtils.getImages(src).then((loadedImages) {
      galleryList = loadedImages;
      galleryList = galleryList[0];
    });
    print(galleryList);
    return galleryList;
  }
  */

  List<Widget> sampleImages() {
    List<Widget> containerList = [];
    for (var i = 1; i < 3; i++) {
      var src = 'assets/livingRoom' + i.toString() + '.jpg';
      print(src);
      containerList.add(Container(
        margin: const EdgeInsets.all(3.0),
        child: Image.asset(src.toString()),
        width: 65,
      ));
    }
    return containerList;
  }

  Widget renderGallery(String src) {
    //   getSampleImages(src);
    Row row = Row(
      children: [],
    );
    galleryList.forEach((element) {
      row.children.add(Image.file(
        File(element.path),
        width: 50,
      ));
    });
    return row;
  }

  Widget renderArchiveButton(int id) {
    if (status == "inActive") {
      return ElevatedButton(
        onPressed: () {
          DataBase.activateProject(id);
        },
        child: const Icon(Icons.settings_backup_restore),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          DataBase.archieveProject(id);
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
                    width: 370,
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 25),
                    decoration: ContainerStyles.getBoxDecoration(),
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
                                        DataBase.deleteImageFolder(
                                            element["id"]);
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
