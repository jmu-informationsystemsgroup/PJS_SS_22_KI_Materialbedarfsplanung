import 'package:flutter/material.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/icon_and_text.dart';

import '../../components/custom_container_border.dart';
import '../../styles/general.dart';

class AllData extends StatelessWidget {
  Content content;
  AllData({required this.content});
  @override
  Widget build(BuildContext context) {
    return CustomContainerBorder(
      color: GeneralStyle.getLightGray(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Alle Daten",
              style: TextStyle(
                color: GeneralStyle.getLightGray(),
                fontStyle: FontStyle.italic,
              )),
          IconAndText(
            icon: Icons.person_pin_circle_outlined,
            text: "Kunde: " + content.client,
            color: Colors.black,
          ),
          IconAndText(
            icon: Icons.location_on_outlined,
            text: "Adresse: " +
                " ${content.street}" +
                " ${content.houseNumber}" +
                " ${content.zip}" +
                " ${content.city}",
            color: Colors.black,
          ),
          IconAndText(
            icon: Icons.calendar_month_outlined,
            text: "Datum: " + content.date,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
