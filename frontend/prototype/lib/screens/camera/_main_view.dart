import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/screens/camera/button_flash.dart';
import 'package:prototype/screens/camera/button_leave.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';
import 'package:flutter/services.dart';
import 'package:prototype/styles/general.dart';
import '../create_new_project/_main_view.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final Function(List<CustomCameraImage>)? updateGallery;
  List<CustomCameraImage> originalGallery;
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
  bool fotoFeedBack = false;
  XFile? pictureFile;
  List<XFile?> previewImages = [];
  List<CustomCameraImage> newImages = [];
  int id = 0;
  bool flashOn = false;

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
    if (widget.originalGallery.isNotEmpty) {
      id = widget.originalGallery.last.id + 1;
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

    controller = CameraController(
      widget.cameras!.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller.setFlashMode(FlashMode.off);
      controller.lockCaptureOrientation(DeviceOrientation.landscapeLeft);
      setState(() {});
    });

    for (var element in widget.originalGallery) {
      if (element.display) {
        previewImages.add(element.image);
      }
    }

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

  /// TODO
  Widget addBlackBox() {
    final availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    double previewWidth = availableHeight * 4 / 3;
    return Container(
      margin: EdgeInsets.fromLTRB(previewWidth, 0, 0, 0),

      //  decoration: BoxDecoration(color: Color.fromARGB(69, 0, 0, 0)),
      decoration: BoxDecoration(color: Colors.black),
    );
  }

  Widget addCameraFeedback() {
    return Container(
      //   height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: GeneralStyle.getLightGray(),
      ),
    );
  }

  Widget getPhotoButton(Alignment alignment) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
      child: Align(
        alignment: alignment,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(17),
            primary: Colors.white,
          ),
          onPressed: () async {
            pictureFile = await controller.takePicture();
            previewImages.add(pictureFile!);

            newImages.add(
              CustomCameraImage(id: id, image: pictureFile!),
            );

            id += 1;
            setState(() {
              fotoFeedBack = true;
            });
            var bla = await Future.delayed(Duration(milliseconds: 45));
            setState(() {
              fotoFeedBack = false;
            });
          },
          child: const Icon(
            Icons.camera,
            color: Color.fromARGB(80, 0, 0, 0),
            size: 45,
          ),
        ),
      ),
    );
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Row(
          children: [
            Expanded(
              flex: 8,
              child: Center(
                child: Stack(
                  children: [
                    /// Workarround um Kamera daran zu hindern sich selbstständig zu drehen, Quelle: https://github.com/flutter/flutter/issues/16587
                    Center(
                      child: CameraPreview(
                        controller,
                        child: addBlackBox(),
                      ),
                      /*
                      child: Expanded(
                        child: NativeDeviceOrientationReader(
                          builder: (context) {
                            NativeDeviceOrientation orientation =
                                NativeDeviceOrientationReader.orientation(
                                    context);

                            int turns;
                            switch (orientation) {
                              case NativeDeviceOrientation.landscapeLeft:
                                turns = 0;
                                break;
                              case NativeDeviceOrientation.landscapeRight:
                                turns = 2;
                                break;
                              case NativeDeviceOrientation.portraitDown:
                                turns = 1;
                                break;
                              default:
                                turns = -1;
                                break;
                            }

                            return RotatedBox(
                              quarterTurns: turns,
                              child: CameraPreview(
                                controller,
                                child: addBlackBox(),
                              ),
                            );
                          },
                        ),
                      ),
                      */
                    ),

                    Center(
                      child: Visibility(
                        visible: fotoFeedBack,
                        child: addCameraFeedback(),
                      ),
                    ),
                    getPhotoButton(Alignment.centerLeft),
                    getPhotoButton(Alignment.centerRight),

                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 25, 30, 25),
                      child: ButtonLeave(
                        leave: () async {
                          Navigator.of(context).pop();

                          widget.updateGallery!(newImages);
                        },
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 25, 100, 25),
                      child: ButtonFLash(
                        flashOn: flashOn,
                        changeFlashMode: () async {
                          if (flashOn) {
                            setState(() {
                              flashOn = false;
                            });
                            controller.setFlashMode(FlashMode.off);
                          } else {
                            setState(() {
                              flashOn = true;
                            });
                            controller.setFlashMode(FlashMode.always);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: preview(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
