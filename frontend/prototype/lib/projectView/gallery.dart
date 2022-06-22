import 'package:flutter/material.dart';
import 'package:prototype/localDrive/file_utils.dart';
import 'dart:io';

import 'package:prototype/projectView/mainView.dart';

class Gallery extends StatefulWidget {
  String src;
  int length;
  Gallery(this.src, [this.length = 8000]);

  _GalleryState createState() {
    // TODO: implement createState
    return _GalleryState(src, length);
  }
}

class _GalleryState extends State<Gallery> {
  String src;
  int length;
  _GalleryState(this.src, [this.length = 8000]);
  var galleryList = [];

  /// befüllt die Liste "galleryList" mit den Bildern aus dem angegbenen Ordner
  List<dynamic> getList() {
    FileUtils.getImages(src).then((loadedImages) {
      galleryList = loadedImages;
    });
    print(length);
    print(galleryList.take(length).toList().toString());
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
    getList();
    return renderGallery();
  }
}
