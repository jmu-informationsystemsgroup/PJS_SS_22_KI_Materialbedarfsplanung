import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite/tflite.dart';
import 'dart:convert';

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

  /// check out model under: https://netron.app/

  static loadModelNency() async {
    var s = await Tflite.loadModel(model: "assets/material_model.tflite");
  }

  static applyOnImageNency() async {
    // var convertedBytes = Float32List(1 * 300 * 400 * 3);
    // var buffer = Float32List.view(convertedBytes.buffer);
    final interpreter = await Interpreter.fromAsset('material_model.tflite');
    var dataBaseOutcome = await DataBase.loadImageFromHardcodedPath();
    File imageFile = File(dataBaseOutcome.path);

    Uint8List uintEightLIst = await imageFile.readAsBytes();

    List<int> intList = [];
    uintEightLIst.forEach((element) {
      intList.add(element);
    });

    img.Image image = img.Image.fromBytes(400, 300, intList);

    List outcomeList = [];
    List widthList = [];
    for (int i = 0; i < 300; i++) {
      List heightList = [];
      for (int j = 0; j < 400; j++) {
        List rgbList = [];
        var pixel = image.getPixel(j, i);
        rgbList.add(img.getRed(pixel).toDouble());
        rgbList.add(img.getGreen(pixel).toDouble());
        rgbList.add(img.getBlue(pixel).toDouble());

        heightList.add(rgbList);
      }
      widthList.add(heightList);
    }
    outcomeList.add(widthList);

    var input = outcomeList;

    var output = List.filled(1, 0).reshape([1, 1]);

    interpreter.run(input, output);

    var lastElementOutcome = outcomeList[outcomeList.length - 1];
    List lastElementWidth = widthList[widthList.length - 1];
    var lastElementHeight = lastElementWidth[lastElementWidth.length - 1];
  }

  static Future<String> applyOnImageNencyVector() async {
    final interpreter = await Interpreter.fromAsset('material_model.tflite');
    var dataBaseOutcome = await DataBase.loadImageFromHardcodedPath();
    File imageFile = File(dataBaseOutcome.path);
    final bytes = await imageFile.readAsBytes();
    List<List<List<double>>> threeHundredList = [];
    List<List<double>> fourHundredList = [];
    List<double> trippleList = [];
    for (int i = 1; i < (360000 + 1); i++) {
      trippleList.add((i - 1).toDouble());
      if (i % 3 == 0) {
        fourHundredList.add(trippleList);
        trippleList = [];
      }
      if (i % 300 == 0) {
        threeHundredList.add(fourHundredList);
        fourHundredList = [];
      }
    }

    List outcomeList = [];
    List widthList = [];
    for (int i = 0; i < 300; i++) {
      List heightList = [];
      for (int j = 0; j < 400; j++) {
        List rgbList = [];
        for (int z = 0; z < 3; z++) {
          rgbList.add(z.toDouble());
        }
        heightList.add(rgbList);
      }
      widthList.add(heightList);
    }
    outcomeList.add(widthList);

    // Float32List floaty = Float32List.fromList(doubleList);

    var input = outcomeList;

    var output = List.filled(1, 0).reshape([1, 1]);

    interpreter.run(input, output);

    print(output.toString() +
        bytes.length.toString() +
        (300 * 400 * 3).toString());

    return output.toString();
  }

  static applyModelOnImage() async {
    print("--------------------------old-------------------");
    var hardcodedImage = await DataBase.loadImageFromHardcodedPath();
    // print(image.toString() + "-------------------");
    // final interpreter = await Interpreter.fromAsset("material_model.tflite");
    /*
    var image2 = await ImagePicker().pickImage(source: ImageSource.camera);
    File image = File(image2!.path.toString());
    */

/*
    var recognitions = await Tflite.detectObjectOnImage(
        path: hardcodedImage.path, asynch: true);
        */

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
