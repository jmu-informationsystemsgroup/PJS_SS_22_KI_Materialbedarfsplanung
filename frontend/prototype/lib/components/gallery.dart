import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'dart:io';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/custom_container_white.dart';

class Gallery extends StatelessWidget {
  List<XFile?> pictures;
  int length;
  Gallery({required this.pictures, this.length = 8000});

/*
  getImages() {
    int projectID = int.parse(widget.src);

    DataBase.getImages(projectID).then((value) => {
          setState(() {
            galleryList = value;
          })
        });

    return galleryList;
  }
  */

  /// geht in einer Schleife durch die galleryList und erzeugt jedesmal ein Imagewidget.
  /// Fügt das Imagewidget in ein Row Widget ein. Dieses wird am Ende zurückgegeben
  Widget renderGallery() {
    Row row = Row(
      children: [],
    );

    for (int i = 0; i < pictures.length; i++) {
      if (i == length) break;
      var element = pictures[i];
      row.children.add(
        FullScreenWidget(
          child: Container(
            margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Image.file(
              File(element!.path),
              width: 50,
            ),
          ),
        ),
      );
    }

    return row;
  }

  @override
  Widget build(BuildContext context) {
    //  getList();
    if (pictures.isNotEmpty) {
      return CustomContainerWhite(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: renderGallery(),
        ),
      );
    } else {
      return Container();
    }
  }
}
