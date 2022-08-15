import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'dart:io';

import 'package:prototype/screen_load_project/_main_view.dart';

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

  /// befüllt die Liste "galleryList" mit den Bildern aus dem angegbenen Ordner
  List<dynamic> getList() {
    int projectID = int.parse(widget.src);
    int length = widget.length;
    try {
      DataBase.getImages(projectID).then((loadedImages) {
        setState(() {
          galleryList = loadedImages;
        });
      });
    } catch (e) {}
    /*
     if (length > 5) {
        print(loadedImages.take(length).toList().toString() +
            "-----------------------------------------------------------------------------------");
      }
    print(length);
    */
    galleryList = galleryList.take(length).toList();

    return galleryList;
  }

  /// geht in einer Schleife durch die galleryList und erzeugt jedesmal ein Imagewidget.
  /// Fügt das Imagewidget in ein Row Widget ein. Dieses wird am Ende zurückgegeben
  Widget renderGallery() {
    Row row = Row(
      children: [],
    );
    galleryList.forEach((element) {
      row.children.add(Image.file(
        File(element.path),
        width: 50,
      ));
    });
    return row;
  }

  @override
  Widget build(BuildContext context) {
    //  getList();
    return renderGallery();
  }
}
