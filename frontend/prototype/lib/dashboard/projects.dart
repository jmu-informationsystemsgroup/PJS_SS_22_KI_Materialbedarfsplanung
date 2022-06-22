import 'package:flutter/material.dart';
import 'package:prototype/localDrive/file_utils.dart';
import 'package:prototype/projectView/mainView.dart';

class Projects extends StatelessWidget {
  List<dynamic> projects;
  Projects(this.projects);

  List<Widget> sampleImages() {
    List<Widget> containerList = [];
    for (var i = 1; i < 3; i++) {
      var src = 'assets/livingRoom' + i.toString() + '.jpg';
      print(src);
      containerList.add(Container(
        margin: const EdgeInsets.all(3.0),
        child: Image.asset(src.toString()),
        width: 65,
      ));
    }
    return containerList;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: projects
          .map(
            (element) => Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProjectView(element["id"])),
                  );
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Row(
                          //    children: sampleImages(),
                          ),
                      width: 150,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Name: " + element["projectName"]),
                          Text("Auftraggeber: " + element["client"]),
                          //  Text("Fälligkeitsdatum: 15.05.2022"),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(5.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    FileUtils.deleteSpecificProject(
                                        element["id"]);
                                  },
                                  child: Icon(Icons.delete),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(5.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      FileUtils.archieveSpecificProject(
                                          element["id"]);
                                    },
                                    child: Icon(Icons.archive)),
                              ),
                            ],
                          )
                        ])
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
