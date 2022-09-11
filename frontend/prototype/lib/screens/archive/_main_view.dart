import 'package:flutter/material.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/navBar.dart';

import 'package:prototype/screens/home/button_new_project.dart';
import '../../backend/data_base_functions.dart';
import '../home/project_list.dart';

class Archieve extends StatefulWidget {
  String title = "Projektübersicht";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ArchieveState();
  }
}

class _ArchieveState extends State<Archieve> {
  static List<Content> allProjects = [];

  @override
  void initState() {
    super.initState();
    activateList();
  }

  activateList() async {
    DataBase.getAllArchivedProjects().then((loadedContent) {
      setState(() {
        allProjects = loadedContent;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
            ProjectList(allProjects, activateList, "inActive"),
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
