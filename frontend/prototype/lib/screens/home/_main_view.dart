import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prototype/components/buttons_order_by.dart';
import 'package:prototype/components/input_field_search.dart';
import 'package:prototype/components/navBar.dart';

import 'package:prototype/screens/home/button_new_project.dart';
import '../../backend/data_base_functions.dart';
import '../../components/project_list.dart';

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
  String searchTerm = "";

  activateList() async {
    DataBase.getAllActiveProjects(searchTerm).then((loadedContent) {
      setState(() {
        allProjects = loadedContent;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    activateList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Projektübersicht"),
        primary: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InputSearch(
                onSearchTermChange: (String term, List list) => {
                      setState(() {
                        searchTerm = term;
                        allProjects = list;
                      })
                    }),
            ButtonsOrderBy(
              searchTerm: searchTerm,
              orderChanged: (List list) => {
                setState(() {
                  allProjects = list;
                })
              },
            ),
            ProjectList(allProjects, activateList),
            projectMessage(),
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
