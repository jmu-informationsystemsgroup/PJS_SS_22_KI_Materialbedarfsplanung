import 'package:flutter/material.dart';
import 'package:prototype/components/appBar_custom.dart';
import 'package:prototype/components/button_row_multiple_icons.dart';
import 'package:prototype/components/custom_container_body.dart';
import 'package:prototype/components/icon_and_text.dart';
import 'package:prototype/screens/home/buttons_order_by.dart';
import 'package:prototype/screens/home/input_field_search.dart';
import 'package:prototype/components/navBar.dart';

import 'package:prototype/screens/home/button_new_project.dart';
import 'package:prototype/screens/profile/_main_view.dart';
import 'package:prototype/styles/container.dart';
import 'package:prototype/styles/general.dart';
import '../../backend/data_base_functions.dart';
import '../../backend/helper_objects.dart';
import 'project_list.dart';

class Home extends StatefulWidget {
  String title = "Alle Projekte";

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  /// Liste von Projekten, diese Wird je nach Einstellung (Suchbegriff, Sortieroptionen, aktive vs abgeschlossene Projekte)
  /// befüllt
  static List<Content> allProjects = [];
  User user = User();
  String searchTerm = "";

  /// statusActive = 1: nur die aktiven Projekte werden angezeigt, bei 0: nur die Abgeschlossenen
  int statusActive = 1;

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
    getUser();
    wait();
  }

  getUser() async {
    DataBase.getUserData().then(
      (loadedContent) {
        if (loadedContent != null) {
          setState(() {
            user = loadedContent;
          });
        }
      },
    );
  }

  /// gibt die Userdaten im Untertitel in der App-Bar an, Link zum User-Profil, falls noch keine User-
  /// Daten vorhanden
  List<Widget> addUserData() {
    if (user.firstName != "" && user.lastName != "") {
      return [
        IconAndText(
            text: "${user.firstName} ${user.lastName}",
            icon: Icons.person,
            color: Colors.black)
      ];
    } else {
      return [
        GestureDetector(
          child: Text("Bitte klicken um Nutzerdaten hinzuzufügen"),
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
              (Route<dynamic> route) => false,
            );
          },
        )
      ];
    }
  }

  /// ändert ob aktive Projekte oder abgeschlossene Projekte geladen werden sollen
  changeStatus() {
    if (statusActive == 0) {
      setState(() {
        statusActive = 1;
      });
    } else {
      statusActive = 0;
    }
  }

  /// bearbeitet den Text auf dem Button für das Aktivieren bzw. Deaktivieren der Projekte
  String getArchievedText() {
    if (statusActive == 0) {
      return "Zurück";
    } else {
      return "Abgeschlossene Projekte";
    }
  }

  /// bearbeitet das Icon auf dem Button für das Aktivieren bzw. Deaktivieren der Projekte
  IconData getIcon() {
    if (statusActive == 0) {
      return Icons.arrow_circle_left_outlined;
    } else {
      return Icons.emoji_events_outlined;
    }
  }

  /// Button für abgeschlossene Projekte
  Widget archieveButton() {
    return CustomButtonRow(
      children: [
        Icon(
          getIcon(),
          color: GeneralStyle.getGreen(),
        ),
        Text(
          getArchievedText(),
          style: TextStyle(
            color: GeneralStyle.getGreen(),
          ),
        )
      ],
      onPressed: () async {
        changeStatus();
        List<Content> newOrderList = await DataBase.getProjects(
          searchTerm: searchTerm,
          statusActive: statusActive,
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScaffoldContainer(
          appBar: CustomAppBar(
            title: "Alle Projekte",
            subTitle: addUserData(),
          ),
          body: SingleChildScrollView(
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
          navBar: NavBar(0),
        ),
      ),
    );
  }
}

/// Wenn noch kein Projekt angelegt wurde verweist ein Pfeil auf den "Projekt anlegen" Button
class projectMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (_HomeState.allProjects.isEmpty) {
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
