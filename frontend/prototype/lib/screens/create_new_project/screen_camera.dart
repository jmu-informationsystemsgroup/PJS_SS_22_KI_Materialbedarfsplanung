import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';

import '_main_view.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  CameraPage({this.cameras, Key? key}) : super(key: key);
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  XFile? pictureFile;
  List<XFile?> images = [];

  Widget getLibrary() {
    Row row = Row(
      children: [],
    );

    if (images.isNotEmpty) {
      for (var picture in images) {
        row.children.add(Image.file(
          File(picture!.path),
          width: 50,
        ));
      }
    }
    return row;
  }

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.cameras!.first,
      ResolutionPreset.max,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Column(
      children: [
        Expanded(
          flex: 8,
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  child: CameraPreview(controller),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(17),
                      primary: Colors.white,
                    ),
                    onPressed: () async {
                      pictureFile = await controller.takePicture();
                      images.add(pictureFile!);
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.camera,
                      color: Color.fromARGB(80, 0, 0, 0),
                      size: 45,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(25),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {
                  NewProject.cash.pictures.addAll(images);
                });
              },
              child: Text("Kameransicht verlassen"),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: getLibrary(),
        )
      ],
    );
  }
}
