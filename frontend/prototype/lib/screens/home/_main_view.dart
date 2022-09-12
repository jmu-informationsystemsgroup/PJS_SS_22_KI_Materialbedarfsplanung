import 'package:flutter/material.dart';
import 'package:prototype/components/appBar_custom.dart';
import 'package:prototype/components/button_row_multiple_icons.dart';
import 'package:prototype/components/custom_container_body.dart';
import 'package:prototype/screens/home/buttons_order_by.dart';
import 'package:prototype/screens/home/input_field_search.dart';
import 'package:prototype/components/navBar.dart';

import 'package:prototype/screens/home/button_new_project.dart';
import 'package:prototype/styles/container.dart';
import 'package:prototype/styles/general.dart';
import '../../backend/data_base_functions.dart';
import '../../backend/helper_objects.dart';
import 'project_list.dart';

class Dashboard extends StatefulWidget {
  String title = "Alle Projekte";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  static List<Content> allProjects = [];
  String searchTerm = "";

  activateList() async {
    DataBase.getProjects(searchTerm: searchTerm).then((loadedContent) {
      setState(() {
        allProjects = loadedContent;
      });
    });
  }

  wait() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  void initState() {
    super.initState();
    activateList();
    wait();
  }

  Widget archieveButton() {
    return CustomButtonRow(
      children: [
        Icon(
          Icons.folder_open,
          color: GeneralStyle.getUglyGreen(),
        ),
        Text(
          "Archiv",
          style: TextStyle(
            color: GeneralStyle.getUglyGreen(),
          ),
        )
      ],
      onPressed: () async {
        List<Content> newOrderList = await DataBase.getProjects(
          searchTerm: searchTerm,
          statusActive: 0,
        );
        setState(
          () {
            allProjects = newOrderList;
            ButtonsOrderBy.selectedIndex = 1000;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomAppBar(title: "Alle Projekte"),
      ),
      body: CustomContainerBody(
        child: SingleChildScrollView(
          child: Column(
            children: [
              InputSearch(
                  onSearchTermChange: (String term, List<Content> list) => {
                        setState(() {
                          searchTerm = term;
                          allProjects = list;
                        })
                      }),
              ButtonsOrderBy(
                searchTerm: searchTerm,
                orderChanged: (List<Content> list) => {
                  setState(() {
                    allProjects = list;
                  })
                },
              ),
              ProjectList(allProjects, activateList),
              projectMessage(),
              AddProjectButton(),
              archieveButton(),
            ],
          ),
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
