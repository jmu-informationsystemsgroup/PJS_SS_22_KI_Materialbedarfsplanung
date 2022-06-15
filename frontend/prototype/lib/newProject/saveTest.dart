import 'package:flutter/material.dart';
import 'package:prototype/localDrive/content.dart';
import 'package:prototype/newProject/input_field.dart';
import '../localDrive/file_utils.dart';
import 'newAddress.dart';
import 'newPhotoButton.dart';

/// SaveTest habe ich ursprünglich als Testklasse verwendet um den Speicherprozess auszuprobieren
/// zukünftig wird es wohl die momentane mainView Klasse ersetzen
class SaveTest extends StatefulWidget {
  // instanzieeren eines Contentobjekts, in dem sämtliche EIngabeinformationen zwischengespeichert werden
  static var cash = Content();

  @override
  _SaveTestState createState() {
    return _SaveTestState();
  }
}

class _SaveTestState extends State<SaveTest> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
