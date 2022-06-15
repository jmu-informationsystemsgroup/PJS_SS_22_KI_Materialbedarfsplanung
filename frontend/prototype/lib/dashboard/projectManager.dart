import 'package:flutter/material.dart';

import 'package:prototype/newProject/newProjectButton.dart';
import 'package:prototype/newProject/mainView.dart';
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
  int i = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Projektübersicht"),
        primary: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            projectMessage(i),
            Projects(_projects),
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
            AddProjectButton()
          ],
        ),
      ),
    );
  }
}

class projectMessage extends StatelessWidget {
  int count;

  projectMessage(this.count);

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
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
