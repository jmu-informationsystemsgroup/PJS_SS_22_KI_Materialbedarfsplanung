import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'dart:io';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:prototype/components/custom_container_white.dart';

class Gallery extends StatefulWidget {
  String src;
  int length;
  Gallery(this.src, [this.length = 8000]);

  @override
  _GalleryState createState() {
    return _GalleryState();
  }
}

class _GalleryState extends State<Gallery> {
  var galleryList = [];

  @override
  initState() {
    galleryList = getImages();
  }

  getImages() {
    int projectID = int.parse(widget.src);

    DataBase.getImages(projectID).then((value) => {
          setState(() {
            galleryList = value;
          })
        });

    return galleryList;
  }

  /// geht in einer Schleife durch die galleryList und erzeugt jedesmal ein Imagewidget.
  /// Fügt das Imagewidget in ein Row Widget ein. Dieses wird am Ende zurückgegeben
  Widget renderGallery() {
    Row row = Row(
      children: [],
    );

    for (int i = 0; i < galleryList.length; i++) {
      if (i == widget.length) break;
      var element = galleryList[i];
      row.children.add(
        FullScreenWidget(
          child: Container(
            margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Image.file(
              File(element["image"].path),
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
    return CustomContainerWhite(child: renderGallery());
  }
}
