import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prototype/dashboard/navBar.dart';

import 'package:prototype/newProject/newProjectButton.dart';
import 'package:prototype/newProject/mainView.dart';
import '../localDrive/file_utils.dart';
import 'projects.dart';

class ProjectManager extends StatefulWidget {
  String title = "Projektübersicht";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProjectManagerState();
  }
}

class _ProjectManagerState extends State<ProjectManager> {
  List<String> _projects = [];
  static List<dynamic> allProjects = [];

  getAllProjects() async {
    FileUtils.readJsonFile().then((loadedContent) {
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
        title: const Text("Projektübersicht"),
        primary: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            projectMessage(),
            Projects(allProjects),
            /*
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      i += 1;
                      _projects.add('Bauprojekt ' + (i).toString());
                    });
                    print(_projects);
                  },
                  child: Text('Neues Projekt anlegen (demoVersion)'),
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(43, 0, 110, 255))),
            ),
            */
            AddProjectButton()
          ],
        ),
      ),
      bottomNavigationBar: NavBar(0),
    );
  }
}

class projectMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (_ProjectManagerState.allProjects.isEmpty) {
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
