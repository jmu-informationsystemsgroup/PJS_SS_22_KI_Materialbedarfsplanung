import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prototype/components/navBar.dart';

import 'package:prototype/home/button_new_project.dart';
import 'package:prototype/screen_create_new_project/_main_view.dart';
import '../backend/data_base_functions.dart';
import '../components/project_list.dart';

class Dashboard extends StatefulWidget {
  String title = "Projektübersicht";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  List<String> _projects = [];
  static List<dynamic> allProjects = [];

  activateList() async {
    DataBase.getAllActiveProjects().then((loadedContent) {
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
        title: const Text("Projektübersicht"),
        primary: true,
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
      bottomNavigationBar: NavBar(0),
    );
  }
}

class projectMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (_DashboardState.allProjects.isEmpty) {
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
