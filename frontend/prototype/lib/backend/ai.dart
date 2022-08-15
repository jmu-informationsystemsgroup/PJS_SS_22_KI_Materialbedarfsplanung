import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite/tflite.dart';

class AI {
  var input = [
    [
      [
        [1.0, 0.0, 0.0],
        [0.0, 1.0, 0.0],
        [0.0, 1.0, 0.0]
      ],
      [
        [1.0, 0.0, 0.0],
        [0.0, 1.0, 0.0],
        [0.0, 1.0, 0.0]
      ],
      [
        [1.0, 0.0, 0.0],
        [0.0, 1.0, 0.0],
        [0.0, 1.0, 0.0]
      ]
    ]
  ];

  // Beispel für Bildregression: https://pub.dev/packages/tflite/example

  Future loadModel() async {
    Tflite.close();
    String? res = await Tflite.loadModel(
      model: "assets/material_model.tflite",
    );
  }

  static applyModelOnImage() async {
    print("---------------------------------------------");
    var hardcodedImage = await DataBase.loadImageFromHardcodedPath();
    // print(image.toString() + "-------------------");
    // final interpreter = await Interpreter.fromAsset("material_model.tflite");
    /*
    var image2 = await ImagePicker().pickImage(source: ImageSource.camera);
    File image = File(image2!.path.toString());
    */

    var recognitions = await Tflite.detectObjectOnImage(
        path: hardcodedImage.path, asynch: true);

    print("######################################################" +
        recognitions!.toString() +
        "#######################################################################");
    // var res = await Tflite.runModelOnImage(path: sth.toString());
    /*
    var output = List.filled(1, 0).reshape([1, 1]);
    interpreter.run(File(image2!.path), output);
    print("######################################################" +
        output[0][0] +
        "#######################################################################");

    interpreter.close();

    return output[0][0];
    */
  }
}
