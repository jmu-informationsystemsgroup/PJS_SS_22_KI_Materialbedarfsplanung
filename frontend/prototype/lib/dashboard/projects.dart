import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prototype/localDrive/file_utils.dart';
import 'package:prototype/projectView/mainView.dart';

import '../projectView/gallery.dart';

class Projects extends StatelessWidget {
  List<dynamic> projects;
  Projects(this.projects);

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
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          Color(0xff1f005c),
                          Color(0xff5b0060),
                          Color(0xff870160),
                        ], // Gradient from https://learnui.design/tools/gradient-generator.html
                        tileMode: TileMode.mirror,
                      ),
                    ),
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
                                  style: TextStyle(color: Colors.white)),
                              Text("Auftraggeber: " + element["client"],
                                  style: TextStyle(color: Colors.white)),
                              //  Text("Fälligkeitsdatum: 15.05.2022"),
                              Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(5.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        FileUtils.deleteSpecificProject(
                                            element["id"]);
                                        FileUtils.deleteImageFolder(
                                            element["id"]);
                                      },
                                      child: Icon(Icons.delete),
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.red),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(5.0),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          FileUtils.archieveSpecificProject(
                                              element["id"]);
                                        },
                                        child: Icon(Icons.archive)),
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
