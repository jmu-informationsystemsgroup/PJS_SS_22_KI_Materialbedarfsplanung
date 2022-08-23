import 'package:flutter/material.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/input_field.dart';
import 'package:url_launcher/url_launcher.dart';

class UserWidget extends StatefulWidget {
  @override
  _UserWidgetState createState() {
    return _UserWidgetState();
  }
}

class _UserWidgetState extends State<UserWidget> {
  User cash = User();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        InputField(
            saveTo: (text) => {cash.firstName = text}, labelText: "Vorname"),
        InputField(
            saveTo: (text) => {cash.lastName = text}, labelText: "Nachname"),
        InputField(
            saveTo: (text) => {cash.customerId = int.parse(text)},
            labelText: "Kundennummer"),
        InputField(
            saveTo: (text) => {cash.address = text}, labelText: "Adresse"),
      ]),
    );
  }
}
