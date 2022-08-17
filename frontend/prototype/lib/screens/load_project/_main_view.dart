import 'package:flutter/material.dart';
import 'package:prototype/components/gallery.dart';
import 'package:prototype/components/navBar.dart';
import 'package:prototype/screens/load_project/projectMap.dart';

import '../../backend/value_calculator.dart';

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
  Map<String, dynamic> calculatedOutcome = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOutcome();
  }

  getOutcome() {
    ValueCalculator.getOutcomeObject(widget.content).then((value) => {
          setState(() {
            calculatedOutcome = value;
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
        Text("Quadratmeter: " +
            calculatedOutcome["totalSquareMeters"].toString()),
        Text("Preis: " + calculatedOutcome["totalPrice"].toString()),
        Text("KI-Ergebnis: " + calculatedOutcome["aiOutcome"].toString()),
        Container(
          margin: const EdgeInsets.all(10.0),
          //    child: Text("Adresse: " + element + "straße"),
        ),
        Text("Fälligkeitsdatum: 15.05.2022"),
        Gallery(content["id"].toString()),
      ]),
      bottomNavigationBar: NavBar(4),
    );
  }
}
