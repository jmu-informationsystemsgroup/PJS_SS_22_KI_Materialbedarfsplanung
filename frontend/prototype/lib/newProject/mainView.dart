import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prototype/localDrive/file_utils.dart';

import '../localDrive/content.dart';
import '../projectView/mainView.dart';
import 'input_field.dart';
import 'mvp.dart';
import 'newAddress.dart';
import 'newPhotoButton.dart';

class NewProject extends StatefulWidget {
  String title = "Neues Projekt";
  // instanzieeren eines Contentobjekts, in dem sämtliche EIngabeinformationen zwischengespeichert werden
  static var cash = Content();
  @override
  State<StatefulWidget> createState() {
    return _NewProjectState();
  }
}

class _NewProjectState extends State<NewProject> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var visability = false;

/*
  Widget preview() {
    Row row = Row(
      children: [],
    );

    if (NewProject.cash.pictures.isNotEmpty) {
      for (var picture in NewProject.cash.pictures) {
        print(picture.toString() +
            "--------------------------------------------------------------");
        row.children.add(Image.file(
          File(picture!.path),
          width: 50,
        ));
      }
    }
    return row;
  }
  
  */

  goToProjectView() async {
    int id = await FileUtils.getId() + 1;
    Map<String, dynamic> content = await FileUtils.getSpecificProject(id);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProjectView(content)),
    );
  }

  goBack() async {
    await Future.delayed(Duration(seconds: 1));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Neues Projekt",
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Column(
              children: <Widget>[
                InputField(InputType.projectName),
                InputField(InputType.client),
                MVP(),
                //  NewAddress(),
                AddPhotoButton(),
                //    preview(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      FileUtils.addToJsonFile(NewProject.cash);
                      FileUtils.saveImages(NewProject.cash.pictures);
                      //    Content.reset(NewProject.cash);
                      setState(() {
                        visability = true;
                      });
                      // goToProjectView();
                      goBack();
                    },
                    child: const Text('Projekt speichern und berechnen'),
                  ),
                ),
                Visibility(
                  child: Text("Projekt erfolgreich gespeichert!"),
                  visible: visability,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
