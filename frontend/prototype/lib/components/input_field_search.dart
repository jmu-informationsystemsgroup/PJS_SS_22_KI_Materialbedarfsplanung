import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';

import '../../styles/container.dart';

class InputSearch extends StatefulWidget {
  final Function(List) onSearchTermChange;

  InputSearch({required this.onSearchTermChange});

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
          widget.onSearchTermChange(searchedProjects);
          //   Dashboard.list = searchedProjects;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Suche",
        ),
      ),
    );
  }
}
