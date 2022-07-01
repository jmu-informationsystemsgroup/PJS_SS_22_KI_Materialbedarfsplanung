import 'package:flutter/material.dart';

import 'package:prototype/newProject/newProjectButton.dart';
import 'package:prototype/newProject/mainView.dart';
import '../localDrive/file_utils.dart';
import '../dashboard/projects.dart';

class Archieve extends StatefulWidget {
  String title = "Projektübersicht";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ArchieveState();
  }
}

class _ArchieveState extends State<Archieve> {
  List<String> _projects = [];
  static List<dynamic> allProjects = [];

  getAllProjects() async {
    FileUtils.readarchievedJsonFile().then((loadedContent) {
      setState(() {
        allProjects = loadedContent;
      });
    });
    return allProjects;
  }

  @override
  Widget build(BuildContext context) {
    getAllProjects();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Archiv",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            projectMessage(),
            Projects(allProjects),
            AddProjectButton()
          ],
        ),
      ),
    );
  }
}

class projectMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (_ArchieveState.allProjects.isEmpty) {
      return Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(20.0),
              child: Text("Noch kein Projekt angelegt"),
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
