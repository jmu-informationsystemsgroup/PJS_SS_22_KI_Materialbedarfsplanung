import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/input_field.dart';
import 'package:prototype/screens/load_project/button_send_mail.dart';
import 'package:prototype/styles/container.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/custom_container_white.dart';

class UserForm extends StatefulWidget {
  final Function(List list) updateValues;
  var aiValue;
  Map<String, dynamic> editUser;
  UserForm(
      {required this.updateValues,
      required this.aiValue,
      this.editUser = User.emptyUser});
  @override
  _UserFormState createState() {
    return _UserFormState();
  }
}

class _UserFormState extends State<UserForm> {
  User cash = User();
  static bool preNameComplete = false;
  static bool familyNameComplete = false;
  static bool addressComplete = false;
  static bool idComplete = false;

  static bool formComplete =
      preNameComplete && familyNameComplete && addressComplete && idComplete;

  @override
  void initState() {
    // TODO: implement initState
    cash = User.mapToUser(widget.editUser);
  }

  Widget mailButtonIfComplete(bool status) {
    if (status) {
      return ButtonSendMail(widget.aiValue, [User.userToMap(cash)]);
    } else
      return Container();
  }

  String _idValue() {
    String idValue = "";
    if (cash.customerId == 0) {
      return idValue;
    } else {
      idValue = cash.customerId.toString();
    }

    return idValue;
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainerWhite(
      child: Column(children: [
        InputField(
          saveTo: (text) => {cash.firstName = text},
          labelText: "Vorname",
          value: cash.firstName,
          formComplete: (formCompleteController) =>
              {preNameComplete = formCompleteController},
          mandatory: true,
        ),
        InputField(
          saveTo: (text) => {cash.lastName = text},
          labelText: "Nachname",
          value: cash.lastName,
          formComplete: (formCompleteController) =>
              {familyNameComplete = formCompleteController},
          mandatory: true,
        ),
        InputField(
          saveTo: (text) => {cash.customerId = int.parse(text)},
          labelText: "Kundennummer",
          formComplete: (formCompleteController) =>
              {idComplete = formCompleteController},
          value: _idValue(),
          mandatory: true,
        ),
        InputField(
          saveTo: (text) => {cash.address = text},
          labelText: "Adresse",
          value: cash.address,
          formComplete: (formCompleteController) =>
              {addressComplete = formCompleteController},
          mandatory: true,
        ),
        ElevatedButton(
            onPressed: () async => {
                  if (formComplete)
                    {
                      widget.updateValues([User.userToMap(cash)]),
                      if (widget.editUser == User.emptyUser)
                        {
                          await DataBase.createUserData(cash),
                        }
                      else
                        {
                          await DataBase.updateUser(cash),
                        },
                    }
                },
            child: Icon(Icons.save)),
      ]),
    );
  }
}
