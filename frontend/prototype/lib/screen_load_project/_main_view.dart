import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/gallery.dart';
import 'package:prototype/screen_load_project/projectMap.dart';

import '../backend/value_calculator.dart';

class ProjectView extends StatefulWidget {
  Map<String, dynamic> content;
  ProjectView(this.content);
  static String src = "";
  @override
  _ProjectViewState createState() {
    return _ProjectViewState();
  }
}

class _ProjectViewState extends State<ProjectView> {
  Map<String, dynamic> outcome = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOutcome();
  }
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

  getOutcome() {
    ValueCalculator.getOutcomeObject(widget.content).then((value) => {
          setState(() {
            outcome = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> content = widget.content;
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
        Text("Quadratmeter: " + outcome["totalSquareMeters"].toString()),
        Text("Preis: " + outcome["totalPrice"].toString()),
        Text("KI-Ergebnis: " + outcome["aiOutcome"].toString()),
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
