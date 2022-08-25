import 'package:flutter/material.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/custom_container_white.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';
import 'package:prototype/screens/load_project/editor.dart';
import 'package:prototype/components/gallery.dart';
import 'package:prototype/components/navBar.dart';
import 'package:prototype/screens/load_project/projectMap.dart';
import 'package:prototype/screens/load_project/webshop_api.dart';

import '../../backend/value_calculator.dart';

class ProjectView extends StatefulWidget {
  Map<String, dynamic> content;
  ProjectView(this.content);

  static String src = "";
  @override
  _ProjectViewState createState() {
    return _ProjectViewState();
  }
}

class _ProjectViewState extends State<ProjectView> {
  Map<String, dynamic> calculatedOutcome = {};
  bool editorVisiblity = false;
  bool textVisiblity = true;
  Map<String, dynamic> content = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOutcome();
    content = widget.content;
  }

  getOutcome() {
    ValueCalculator.getOutcomeObject(widget.content).then((value) => {
          setState(() {
            calculatedOutcome = value;
          })
        });
  }

  bool changeBool(bool input) {
    if (input == true) {
      return false;
    } else {
      return true;
    }
  }

  Icon getIcon() {
    if (textVisiblity) {
      return Icon(Icons.edit);
    } else
      return Icon(Icons.close);
  }

  @override
  Widget build(BuildContext context) {
    // getJsonValues();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          content["projectName"],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Center(child: ProjectMap()),
          CustomContainerWhite(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: textVisiblity,
                  child: Column(
                    children: [
                      Text("Auftraggeber: " + content["client"]),
                      Text("Datum: " + content["date"]),
                    ],
                  ),
                ),
                ElevatedButton(
                  child: getIcon(),
                  onPressed: () {
                    setState(() {
                      editorVisiblity = changeBool(editorVisiblity);
                      textVisiblity = changeBool(textVisiblity);
                    });
                  },
                ),
                Visibility(
                  visible: editorVisiblity,
                  child: EditorWidget(
                    input: content,
                    route: ((data) {
                      content = Content.createMap(data);
                    }),
                  ),
                ),
              ],
            ),
          ),
          // test to check if Project view is able to load data, which had been entered before
          CustomContainerWhite(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("KI-Ergebnis: " +
                    calculatedOutcome["aiOutcome"].toString()),
                Text("KI-Preis: " +
                    calculatedOutcome["totalAiPrice"].toString()),
              ],
            ),
          ),
          /*
            Text("Quadratmeter: " +
                    calculatedOutcome["totalSquareMeters"].toString()),
           Text("Preis: " + calculatedOutcome["totalPrice"].toString()),
*/
          Container(
            margin: const EdgeInsets.all(10.0),
            //    child: Text("Adresse: " + element + "straße"),
          ),
          Gallery(content["id"].toString()),
          Webshop(
            aiValue: calculatedOutcome["aiOutcome"],
          )
        ]),
      ),
      bottomNavigationBar: NavBar(4),
    );
  }
}
