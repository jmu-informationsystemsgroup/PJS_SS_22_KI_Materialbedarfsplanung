import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prototype/localDrive/file_utils.dart';
import 'package:prototype/localDrive/content.dart';
import 'package:prototype/projectView/gallery.dart';
import 'package:prototype/projectView/projectGalerydemoVersion.dart';
import 'package:prototype/projectView/projectMap.dart';

class ProjectView extends StatefulWidget {
  Map<String, dynamic> content;
  ProjectView(this.content);
  static String src = "";
  _ProjectViewState createState() {
    print(content.toString());
    // TODO: implement createState
    return _ProjectViewState(content);
  }
}

class _ProjectViewState extends State<ProjectView> {
  Map<String, dynamic> content;
  _ProjectViewState(this.content);

/*
  Map<String, dynamic> getJsonValues() {
    FileUtils.getSpecificProject(id).then((loadedContent) {
      setState(() {
        content = loadedContent;
        ProjectView.src = loadedContent["id"].toString();
      });
    });
    return content;
  }
  */

  double getSquareMeter() {
    var squareMeters = content["squareMeters"];
    double totalSquareMeters = 0.0;
    squareMeters.forEach((element) {
      double actualSquareMeters = element["width"]! * element["height"]!;
      totalSquareMeters = totalSquareMeters + actualSquareMeters;
    });
    return totalSquareMeters;
  }

  @override
  Widget build(BuildContext context) {
    // getJsonValues();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          content["projectName"],
        ),
      ),
      body: Column(children: [
        // test to check if Project view is able to load data, which had been entered before
        Center(child: ProjectMap()),
        Text("Auftraggeber: " + content["client"]),
        Text("Quadratmeter: " + getSquareMeter().toString()),
        Container(
          margin: const EdgeInsets.all(10.0),
          //    child: Text("Adresse: " + element + "straße"),
        ),
        Text("Fälligkeitsdatum: 15.05.2022"),
        Gallery(content["id"].toString()),
      ]),
    );
  }
}
