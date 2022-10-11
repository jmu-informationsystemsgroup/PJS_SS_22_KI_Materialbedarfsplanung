import 'package:flutter/material.dart';
import 'package:prototype/backend/value_calculator.dart';
import 'package:prototype/components/button_row_multiple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../backend/helper_objects.dart';

class ButtonSendMail extends StatefulWidget {
  CalculatorOutcome outcome;
  User userData;
  ButtonSendMail({required this.outcome, required this.userData});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ButtonSendMailState();
  }
}

class _ButtonSendMailState extends State<ButtonSendMail> {
  Future<void> _launchUrl(urlString) async {
    Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  String createEmailContent(User user) {
    String body =
        "Guten Tag Herr Schäfer von\n Sprachtelprofi, \n \n die Ermittlung innerhalb der App " +
            "hat ergeben, dass der optimale Bedarf an Spachtelbar Classic einen Wert von ${widget.outcome.priceMaterial.toStringAsFixed(2)} € " +
            "für mein anstehendes Bauprojekt betragen wird. \n \n" +
            "Gerne würde ich mit Ihnen genaueres darüber aushandeln. \n" +
            "Anbei meine Kundendaten: \n" +
            "- ${user.firstName} ${user.lastName} \n" +
            "- Kundennummer ${user.customerId} \n" +
            "- Adresse ${user.street} ${user.houseNumber}, ${user.zip} ${user.city} \n \n" +
            "Mit freundlichen Grüßen \n \n ${user.firstName} ${user.lastName}";

    return body;
  }

  @override
  Widget build(BuildContext context) {
    String subject = "App-Bedarf ermittelt: Interesse an Spachtelmasse";
    String body = "";
    if (User.userToMap(widget.userData).toString() !=
        User.userToMap(User()).toString()) {
      body = createEmailContent(widget.userData);
    }

    return CustomButtonRow(
      children: [Icon(Icons.send), Text("Abschicken")],
      onPressed: () {
        _launchUrl("mailto:post@spachtelprofi.com?subject=$subject&body=$body");
      },
    );
  }
}
