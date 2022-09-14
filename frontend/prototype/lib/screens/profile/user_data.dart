import 'package:flutter/material.dart';

import '../../backend/helper_objects.dart';

class DisplayUserData extends StatelessWidget {
  User user;
  DisplayUserData({required this.user});
  @override
  Widget build(BuildContext context) {
    return Text(
      "Bitte Daten kontrollieren: \nName: " +
          user.firstName.toString() +
          " " +
          user.lastName.toString() +
          "\nKundennummer: " +
          user.customerId.toString() +
          "\nAdresse: " +
          user.address.toString(),
    );
  }
}
