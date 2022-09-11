import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'dart:io';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/custom_container_white.dart';
import 'package:path/path.dart';
import 'package:file_support/file_support.dart';

class Gallery extends StatelessWidget {
  List<CustomCameraImage> pictures;
  int length;
  bool creationMode;
  Function(CustomCameraImage) deleteFunction;
  Gallery(
      {required this.pictures,
      this.length = 8000,
      this.creationMode = false,
      required this.deleteFunction});

  getImageName(File file) {
    if (!creationMode) {
      String pathWithExtension =
          FileSupport().getFileNameWithoutExtension(file).toString();
      List<String> pathList = pathWithExtension.split("_");
      String pathWithoutProjectId = pathList.last;
      List<String> name = pathWithoutProjectId.split(".");

      return Text(name.first);
    } else
      return Container();
  }

  /// geht in einer Schleife durch die galleryList und erzeugt jedesmal ein Imagewidget.
  /// Fügt das Imagewidget in ein Row Widget ein. Dieses wird am Ende zurückgegeben
  Widget renderGallery() {
    Row row = Row(
      children: [],
    );

    for (int i = 0; i < pictures.length; i++) {
      CustomCameraImage element = pictures[i];
      if (element.display) {
        row.children.add(
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromARGB(255, 206, 206, 206),
              ),
            ),
            child: Column(
              children: [
                FullScreenWidget(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                    child: Image.file(
                      File(element.image.path),
                      width: 80,
                    ),
                  ),
                ),
                Text("${element.id}"),
                ElevatedButton(
                    onPressed: () {
                      deleteFunction(element);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(20, 0, 0, 0),
                      shadowColor: Colors.transparent,
                    ),
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              ],
            ),
          ),
        );
      }
    }

    return row;
  }

  @override
  Widget build(BuildContext context) {
    //  getList();
    if (pictures.isNotEmpty) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: renderGallery(),
      );
    } else {
      return Container();
    }
  }
}
