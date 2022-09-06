import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';
import 'package:flutter/services.dart';
import '../screens/create_new_project/_main_view.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final Function(List<XFile?>)? updateGallery;
  List<XFile?> originalGallery;
  CameraPage(
      {this.cameras,
      Key? key,
      this.updateGallery,
      this.originalGallery = const []})
      : super(key: key);
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  XFile? pictureFile;
  List<XFile?> previewImages = [];
  List<XFile?> newImages = [];

  Widget preview() {
    Column column = Column(
      children: [],
    );

    if (previewImages.isNotEmpty) {
      for (var picture in previewImages) {
        column.children.add(Image.file(
          File(picture!.path),
          width: 50,
        ));
      }
    }
    return column;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    controller = CameraController(
      widget.cameras!.first,
      ResolutionPreset.medium,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    previewImages.addAll(widget.originalGallery);
    print(">>>>>>>>>>>>>>>>>>>>>>${widget.cameras}");
  }

  @override
  void dispose() {
    controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
    return Row(
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
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(17),
                      primary: Colors.white,
                    ),
                    onPressed: () async {
                      pictureFile = await controller.takePicture();
                      previewImages.add(pictureFile!);
                      newImages.add(pictureFile!);
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
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(17),
                      primary: Colors.white,
                    ),
                    onPressed: () async {
                      pictureFile = await controller.takePicture();
                      previewImages.add(pictureFile!);
                      newImages.add(pictureFile!);
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
              Container(
                margin: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                child: Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      primary: Colors.red,
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();

                      widget.updateGallery!(newImages);
                    },
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ],
          ),
        ),
        /*
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(25),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();

                widget.updateGallery!(newImages);
              },
              child: Icon(Icons.close),
            ),
          ),
        ),
        */
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: preview(),
          ),
        )
      ],
    );
  }
}
