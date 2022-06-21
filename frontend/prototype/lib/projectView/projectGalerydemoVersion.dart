import 'package:flutter/material.dart';

class ProjectGalery extends StatelessWidget {
  List<Widget> sampleImages(var room) {
    List<Widget> containerList = [];
    for (var i = 1; i < 4; i++) {
      var src = 'assets/' + room.toString() + i.toString() + '.jpg';
      print(src);
      containerList.add(Container(
        margin: const EdgeInsets.all(3.0),
        child: Image.asset(src.toString()),
        width: 100,
      ));
    }
    return containerList;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 206, 206, 206))),
          child: Column(
            children: <Widget>[
              Text("Wohnzimmer"),
              Row(
                children: sampleImages("livingRoom"),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 206, 206, 206))),
          child: Column(
            children: <Widget>[
              Text("Badezimmer"),
              Row(
                children: sampleImages("bathRoom"),
              )
            ],
          ),
        )
      ],
    );
  }
}
