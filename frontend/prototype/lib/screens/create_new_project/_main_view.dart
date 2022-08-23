import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prototype/components/navBar.dart';
import 'package:prototype/screens/create_new_project/input_field_date.dart';
import 'package:prototype/screens/home/_main_view.dart';
import 'package:prototype/backend/data_base_functions.dart';

import '../../backend/helper_objects.dart';
import '../load_project/_main_view.dart';
import '../../components/input_field.dart';
import 'mvp_checklist.dart';
import 'mvp_walls.dart';
import 'button_add_photo.dart';

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
  int projectId = 0;

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

  goToProjectView(int id) async {
    await Future.delayed(Duration(seconds: 1));
    var projects = await DataBase.getSpecificProject(id);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => ProjectView(projects[0])),
      (Route<dynamic> route) => false,
    );
  }

  goBack() async {
    await Future.delayed(Duration(seconds: 1));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()),
      (Route<dynamic> route) => false,
    );
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
                InputField(
                  saveTo: (text) => {NewProject.cash.projectName = text},
                  labelText: "Name",
                ),
                //  NewAddress(),
                AddPhotoButton(),
                InputField(
                  saveTo: (text) => {NewProject.cash.client = text},
                  labelText: "Auftraggeber",
                ),
                InputDate(),
                MVPWalls(),
                MVPChecklist(),
                //    preview(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      //    Content.reset(NewProject.cash);
                      setState(() async {
                        visability = true;
                        projectId =
                            await DataBase.createNewProject(NewProject.cash);
                        NewProject.cash = Content(); //reset
                        goToProjectView(projectId);
                      });

                      // goBack();
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
        bottomNavigationBar: NavBar(1),
      ),
    );
  }
}
