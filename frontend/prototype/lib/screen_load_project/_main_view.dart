import 'dart:io';

import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/gallery.dart';
import 'package:prototype/screen_load_project/projectMap.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tflite/tflite.dart';

import '../components/gallery2.dart';

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
  var images = [];
  String outcome = "konnte nicht ermittelt werden";
  File pickedImage = File("");
  bool imagesLoaded = false;

  @override
  initState() {
    super.initState();
    totalSquareMeters = getSquareMeter();
    images = loadImages();
    loadAiModel();
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

  loadImages() {
    var images = [];
    DataBase.getImages(widget.content["id"].toString()).then((imagelist) => {
          imagelist.forEach((element) {
            setState(() {
              images.add(element);
              imagesLoaded = true;
            });
          })
        });

    return images;
  }

  loadAiModel() async {
    var model = await Tflite.loadModel(model: "assets/material_model.tflite");
    print("++++++++++++++++++++++++++++++++" + model.toString());
  }

// applyModelOnImage methode im inder video wird nirgends aufgraufen
  applyModelOnImage() async {
    File sth = File("assets/bathRoom1.jpg");
    // woher weiß das programm im inder video, welches modell gemeint ist, er stellt keine verknüpfung modell, das modell wird nirgends gespeichert, auch
    // sonst wird die load model mthode nirgends nochmal verwendet außer in init state
    var res = await Tflite.runModelOnImage(path: sth.toString());

    print("-------------------------------------" + res.toString());

    setState(() {
      outcome = res.toString();
    });
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
    // applyModelOnImage();
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
        // Image(image: AssetImage('assets/bathRoom1.jpg')),
        Text("Auftraggeber: " + content["client"]),
        Text("Quadratmeter: " + totalSquareMeters.toString()),
        Text("Preis: " + totalPrice.toString()),
        Text("KI-Ergebnis: " + outcome),
        Container(
          margin: const EdgeInsets.all(10.0),
          //    child: Text("Adresse: " + element + "straße"),
        ),
        Text("Fälligkeitsdatum: 15.05.2022"),
        Gallery2(images),
      ]),
    );
  }
}
