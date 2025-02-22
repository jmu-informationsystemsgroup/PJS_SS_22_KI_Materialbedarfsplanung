import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/components/button_column_multiple_icons.dart';
import 'package:prototype/styles/general.dart';

import '../../../styles/container.dart';
import '../../backend/helper_objects.dart';

/// liefert die Buttons zurück die für die Sortierfunktionen zuständig sind
class ButtonsOrderBy extends StatefulWidget {
  static int selectedIndex = 1000;
  final Function(List<Content>) orderChanged;
  String searchTerm;
  ButtonsOrderBy({required this.orderChanged, required this.searchTerm});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ButtonsOrderByState();
  }
}

/// ändert die Farbe der Buttons die gerade für die Sortierfunktion ausgewählt wurden
class _ButtonsOrderByState extends State<ButtonsOrderBy> {
  currentOrderColor(int bottenrowPosition) {
    if (ButtonsOrderBy.selectedIndex == bottenrowPosition) {
      return Color.fromARGB(255, 115, 115, 115);
    } else
      return Color.fromARGB(255, 196, 196, 196);
  }

  @override
  Widget build(BuildContext context) {
    Row buttonrow = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CustomButtonColumn(
          enableShaddow: false,
          children: [
            Icon(
              Icons.person_pin_circle_outlined,
              color: currentOrderColor(0),
            ),
            Text(
              "Kunde",
              style: TextStyle(
                color: currentOrderColor(0),
              ),
            ),
          ],
          onPressed: () async {
            List<Content> newOrderList = await DataBase.getProjects(
              searchTerm: widget.searchTerm,
              orderByParamter: "client",
            );
            widget.orderChanged(newOrderList);
            setState(() {
              ButtonsOrderBy.selectedIndex = 0;
            });
          },
        ),
        CustomButtonColumn(
          enableShaddow: false,
          children: [
            Icon(
              Icons.location_on_outlined,
              color: currentOrderColor(1),
            ),
            Text(
              "Ort",
              style: TextStyle(
                color: currentOrderColor(1),
              ),
            ),
          ],
          onPressed: () async {
            List<Content> newOrderList = await DataBase.getProjects(
              searchTerm: widget.searchTerm,
              orderByParamter: "zip",
            );
            widget.orderChanged(newOrderList);
            setState(() {
              ButtonsOrderBy.selectedIndex = 1;
            });
          },
        ),
        CustomButtonColumn(
          enableShaddow: false,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              color: currentOrderColor(2),
            ),
            Text(
              "Datum",
              style: TextStyle(
                color: currentOrderColor(2),
              ),
            )
          ],
          onPressed: () async {
            List<Content> newOrderList = await DataBase.getProjects(
              searchTerm: widget.searchTerm,
              orderByParamter: "date",
            );
            widget.orderChanged(newOrderList);
            setState(() {
              ButtonsOrderBy.selectedIndex = 2;
            });
          },
        ),
      ],
    );

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              "Sortieren nach:",
              style: TextStyle(
                color: GeneralStyle.getLightGray(),
              ),
            ),
          ),
          SingleChildScrollView(
            child: buttonrow,
            scrollDirection: Axis.horizontal,
          ),
        ],
      ),
      decoration: ContainerStyles.borderBottom(),
    );
  }
}
