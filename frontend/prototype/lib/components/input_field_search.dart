import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/screens/home/_main_view.dart';

import '../../styles/container.dart';

class InputSearch extends StatefulWidget {
  @override
  _InputSearchState createState() {
    return _InputSearchState();
  }
}

class _InputSearchState extends State<InputSearch> {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ContainerStyles.getMargin(),
      child: TextField(
        controller: nameController,
        onChanged: (text) async {
          var searchedProjects = await DataBase.searchProject(text);

          Dashboard.list = searchedProjects;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Suche",
        ),
      ),
    );
  }
}
