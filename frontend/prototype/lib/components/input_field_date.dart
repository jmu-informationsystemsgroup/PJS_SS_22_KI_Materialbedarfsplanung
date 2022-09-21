import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';

import '../styles/container.dart';

class InputDate extends StatefulWidget {
  String value;
  Function(String) saveTo;
  InputDate({required this.saveTo, this.value = ""});
  @override
  _InpuDateState createState() {
    // TODO: implement createState
    return _InpuDateState();
  }
}

class _InpuDateState extends State<InputDate> {
  TextEditingController dateinput = TextEditingController();
  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
    dateinput.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ContainerStyles.getMargin(),
      child: TextField(
          controller: dateinput,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                locale: Locale('de', 'DE'),
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2100));

            if (pickedDate != null) {
              String formattedDate =
                  DateFormat('dd.MM.yyyy').format(pickedDate);

              setState(() {
                dateinput.text =
                    formattedDate; //set output date to TextField value.
                widget.saveTo(formattedDate);
              });
            }
          },
          decoration: ContainerStyles.getInputStyleIconGreen(
              "Datum", Icons.calendar_month_outlined)),
    );
  }
}
