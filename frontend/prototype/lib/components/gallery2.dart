import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'dart:io';

import 'package:prototype/screen_load_project/_main_view.dart';

class Gallery2 extends StatefulWidget {
  var images;
  Gallery2(this.images);

  @override
  _GalleryState createState() {
    return _GalleryState();
  }
}

class _GalleryState extends State<Gallery2> {
  /// geht in einer Schleife durch die galleryList und erzeugt jedesmal ein Imagewidget.
  /// Fügt das Imagewidget in ein Row Widget ein. Dieses wird am Ende zurückgegeben
  Widget renderGallery() {
    var images = widget.images;
    Row row = Row(
      children: [],
    );
    images.forEach((element) {
      row.children.add(Image.file(
        File(element.path),
        width: 50,
      ));
    });
    return row;
  }

  @override
  Widget build(BuildContext context) {
    return renderGallery();
  }
}
