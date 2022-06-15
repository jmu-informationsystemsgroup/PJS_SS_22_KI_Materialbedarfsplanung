import 'package:flutter/material.dart';

import 'package:prototype/newProject/newProjectButton.dart';
import 'package:prototype/dashboard/projects.dart';

class Archive extends StatelessWidget {
  String title = "Archiv";
  List<String> archived = [];

  @override
  Widget build(BuildContext context) {
    int i = archived.length;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Archiv"),
        primary: true,
      ),
      body: Column(
        children: [archiveMessage(i), Projects(archived), AddProjectButton()],
      ),
    );
  }
}

class archiveMessage extends StatelessWidget {
  int count;

  archiveMessage(this.count);

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      return Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(20.0),
              child: Text("Keine Projekte im Archiv"),
            ),
            const Icon(Icons.arrow_downward),
          ],
        ),
      );
    }
    // TODO: implement build
    return SizedBox.shrink();
  }
}
