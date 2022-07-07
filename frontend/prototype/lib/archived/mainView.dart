import 'package:flutter/material.dart';
import 'package:prototype/dashboard/navBar.dart';

import 'package:prototype/newProject/newProjectButton.dart';
import 'package:prototype/newProject/mainView.dart';
import '../localDrive/file_utils.dart';
import '../dashboard/project.dart';

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

  activateList() async {
    FileUtils.getAllArchivedProjects().then((loadedContent) {
      setState(() {
        allProjects = loadedContent;
      });
    });
    return allProjects;
  }

  @override
  Widget build(BuildContext context) {
    activateList();
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
            ProjectList(allProjects),
            AddProjectButton()
          ],
        ),
      ),
      bottomNavigationBar: NavBar(2),
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
