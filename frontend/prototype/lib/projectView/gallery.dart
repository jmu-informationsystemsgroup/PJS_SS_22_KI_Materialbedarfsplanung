import 'package:flutter/material.dart';
import 'package:prototype/localDrive/file_utils.dart';
import 'dart:io';

import 'package:prototype/projectView/mainView.dart';

class Gallery extends StatefulWidget {
  _GalleryState createState() {
    // TODO: implement createState
    return _GalleryState();
  }
}

class _GalleryState extends State<Gallery> {
  var galleryList = [];

  /// befüllt die Liste "galleryList" mit den Bildern aus dem angegbenen Ordner
  List<dynamic> getList() {
    FileUtils.getImages(ProjectView.src).then((loadedImages) {
      galleryList = loadedImages;
    });
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
    getList();
    return renderGallery();
  }
}
