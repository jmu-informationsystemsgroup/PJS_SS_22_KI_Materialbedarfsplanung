import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/backend/helper_objects.dart';

import '../../../styles/container.dart';

class InputSearch extends StatefulWidget {
  final Function(String, List<Content>) onSearchTermChange;

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
    return TextField(
      controller: nameController,
      onChanged: (searchTerm) async {
        List<Content> searchedProjects =
            await DataBase.getProjects(searchTerm: searchTerm);
        widget.onSearchTermChange(searchTerm, searchedProjects);
        //   Dashboard.list = searchedProjects;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Suche",
      ),
    );
  }
}
