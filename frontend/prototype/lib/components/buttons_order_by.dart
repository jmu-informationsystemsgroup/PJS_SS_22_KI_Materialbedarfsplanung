import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';

import '../../styles/container.dart';

class ButtonsOrderBy extends StatelessWidget {
  final Function(List) orderChanged;
  ButtonsOrderBy({required this.orderChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text("Order by: "),
        ElevatedButton(
          child: Text("Client"),
          onPressed: () async {
            List newOrderList = await DataBase.getAllActiveProjects("client");
            orderChanged(newOrderList);
          },
        ),
        ElevatedButton(
          child: Text("Name"),
          onPressed: () async {
            List newOrderList =
                await DataBase.getAllActiveProjects("projectName");
            orderChanged(newOrderList);
          },
        ),
        ElevatedButton(
          child: Text("Datum"),
          onPressed: () async {
            List newOrderList = await DataBase.getAllActiveProjects("date");
            orderChanged(newOrderList);
          },
        )
      ],
    );
  }
}
