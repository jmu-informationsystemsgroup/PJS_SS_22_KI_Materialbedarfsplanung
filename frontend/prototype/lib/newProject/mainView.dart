import 'package:flutter/material.dart';
import 'package:prototype/localDrive/file_utils.dart';

import 'package:prototype/newProject/saveTest.dart';

import '../localDrive/content.dart';
import 'input_field.dart';
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Neues Projekt"),
          primary: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Column(
              children: <Widget>[
                InputField(InputType.projectName),
                InputField(InputType.client),
                NewAddress(),
                AddPhotoButton(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      FileUtils.writeJsonFile(SaveTest.cash);
                    },
                    child: const Text('Projekt speichern'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
