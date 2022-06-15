import 'package:flutter/material.dart';

class NewAddress extends StatelessWidget {
  String title = "Archiv";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 206, 206, 206))),
      child: Wrap(
        spacing: 20, // to apply margin in the main axis of the wrap
        runSpacing: 20, // to apply margin in the cross axis of the wrap
        children: <Widget>[
          Text("Adresse"),
          Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Straße',
                  ),
                ),
              ),
              SizedBox(width: 5),
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Hausnummer',
                  ),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Stadt',
                  ),
                ),
              ),
              SizedBox(width: 5),
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Postleitzahl',
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
