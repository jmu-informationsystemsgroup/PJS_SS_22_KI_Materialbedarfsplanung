import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/gallery.dart';
import 'package:prototype/screen_load_project/projectMap.dart';

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
  double totalSquareMeters = 0.0;
  double totalPrice = 0.0;
  double aiOutcome = 0.0;

  @override
  initState() {
    totalSquareMeters = getSquareMeter();
    aiOutcome = getAIOutcome();
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

  double getAIOutcome() {
    DataBase.getImages(widget.content["id"]).then((images) {
      images.forEach((element) async {
        setState(() {
          aiOutcome = aiOutcome + element["aiValue"];
        });
      });
    });
    return aiOutcome;
  }

  double getSquareMeter() {
    DataBase.getWalls(widget.content["id"]).then((walls) {
      walls.forEach((element) async {
        double width = 0.0;
        double height = 0.0;
        try {
          width = element["width"];
          height = element["height"];
        } catch (e) {}
        double actualSquareMeters = width * height;
        setState(() {
          totalSquareMeters = totalSquareMeters + actualSquareMeters;
        });
      });
    });

    return totalSquareMeters;
  }

  double getPrice() {
    String material = widget.content["material"];
    Map<String, double> valueInterpreter = {"Q2": 0.7, "Q3": 2, "Q4": 3.5};
    setState(() {
      totalPrice = totalSquareMeters * valueInterpreter[material]!;
    });

    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> content = widget.content;
    totalPrice = getPrice();
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
        Text("Quadratmeter: " + totalSquareMeters.toString()),
        Text("Preis: " + totalPrice.toString()),
        Text("KI-Ergebnis: " + aiOutcome.toString()),
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
