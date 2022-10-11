import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/input_field.dart';
import 'package:prototype/components/input_field_date.dart';
import 'package:prototype/components/checklist_quality.dart';
import 'package:prototype/components/input_field_address.dart';

import '../create_new_project/_main_view.dart';

class EditorWidget extends StatelessWidget {
  Content input;
  Function(Content) route;
  EditorWidget({required this.input, required this.route});

  @override
  Widget build(BuildContext context) {
    Content data = input;
    return Column(
      children: [
        InputField(
          saveTo: (text) => {data.projectName = text},
          labelText: "Projektname",
          icon: Icons.discount_outlined,
          value: input.projectName,
        ),
        InputField(
          saveTo: (text) => {data.client = text},
          labelText: "Kunde",
          icon: Icons.person_pin_outlined,
          value: input.client,
        ),
        InputDate(
          saveTo: (text) => {data.date = text},
          value: input.date,
        ),
        AddressInput(
          adress: Adress(
              street: input.street,
              houseNumber: input.houseNumber,
              zip: input.zip,
              city: input.city),
          updateAddress: (value) {
            data.street = value.street;
            data.houseNumber = value.houseNumber;
            data.zip = value.zip;
            data.city = value.city;
          },
        ),
        InputField(
          saveTo: (text) => {data.comment = text},
          labelText: "Kommentar",
          value: input.comment,
          maxLines: 6,
        ),
        QualityChecklist(
          value: input.material,
          changeQuality: (material) {
            data.material = material;
          },
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
