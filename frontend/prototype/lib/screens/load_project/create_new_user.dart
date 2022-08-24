import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/input_field.dart';
import 'package:prototype/screens/load_project/button_send_mail.dart';
import 'package:prototype/styles/container.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateUser extends StatefulWidget {
  final Function() updateValues;
  var aiValue;
  CreateUser({required this.updateValues, this.aiValue});
  @override
  _CreateUserState createState() {
    return _CreateUserState();
  }
}

class _CreateUserState extends State<CreateUser> {
  User cash = User();
  bool userComplete = false;

  @override
  void initState() {
    // TODO: implement initState
    userComplete = false;
  }

  Widget mailButtonIfComplete(bool status) {
    if (status) {
      return ButtonSendMail(widget.aiValue, [User.createMap(cash)]);
    } else
      return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ContainerStyles.getBoxDecoration(),
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
        ElevatedButton(
            onPressed: () async => {
                  await DataBase.createUserData(cash),
                  setState(() {
                    userComplete = true;
                  })
                },
            child: Text("Userdaten speichern")),
        mailButtonIfComplete(userComplete)
      ]),
    );
  }
}
