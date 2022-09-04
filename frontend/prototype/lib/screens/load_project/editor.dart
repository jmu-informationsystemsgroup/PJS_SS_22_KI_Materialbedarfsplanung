import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/input_field.dart';
import 'package:prototype/components/input_field_date.dart';

import '../create_new_project/_main_view.dart';

class EditorWidget extends StatelessWidget {
  Content input;
  Function(Content) route;
  EditorWidget({required this.input, required this.route});

  @override
  Widget build(BuildContext context) {
    Content data = input;
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${data.comment}");
    return Column(
      children: [
        InputField(
          saveTo: (text) => {data.projectName = text},
          labelText: "Name",
          value: input.projectName,
        ),
        InputField(
          saveTo: (text) => {data.client = text},
          labelText: "Auftraggeber",
          value: input.client,
        ),
        InputDate(
          saveTo: (text) => {data.date = text},
          value: input.date,
        ),
        InputField(
          saveTo: (text) => {data.comment = text},
          labelText: "Kommentar",
          value: input.comment,
          maxLines: 6,
        ),
        ElevatedButton(
            onPressed: () {
              route(data);
              DataBase.updateContent(input.id, data);
            },
            child: Icon(Icons.save))
      ],
    );
  }
}
