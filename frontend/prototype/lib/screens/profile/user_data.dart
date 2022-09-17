import 'package:flutter/material.dart';
import 'package:prototype/styles/general.dart';

import '../../backend/helper_objects.dart';

class DisplayUserData extends StatelessWidget {
  User user;
  DisplayUserData({required this.user});

  Widget textLine({required String label, required String value}) {
    return RichText(
      textScaleFactor: 1.3,
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: GeneralStyle.getLightGray(),
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontStyle: FontStyle.normal,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  Widget dataLine({required IconData icon, required List<Widget> textValues}) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
              flex: 1,
              child: Icon(
                icon,
                color: GeneralStyle.getDarkGray(),
              )),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: textValues,
            ),
          )
        ],
      ),
    );
  }

  String getCustomerId() {
    if (user.customerId == 0) {
      return "";
    } else {
      return "${user.customerId}";
    }
  }

  Widget columnData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Meine Kundendaten:"),
        Text(""),
        dataLine(icon: Icons.person, textValues: [
          textLine(label: "Vorname: ", value: user.firstName),
          textLine(label: "Nachname: ", value: user.lastName),
        ]),
        dataLine(icon: Icons.grid_3x3, textValues: [
          textLine(label: "Kundennummer: ", value: getCustomerId()),
        ]),
        dataLine(icon: Icons.location_on_outlined, textValues: [
          textLine(
              label: "Straße, Hausnummer: ",
              value: "${user.street} ${user.houseNumber}"),
          textLine(label: "PLZ, Stadt: ", value: "${user.zip} ${user.city}"),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return columnData();
  }
}
