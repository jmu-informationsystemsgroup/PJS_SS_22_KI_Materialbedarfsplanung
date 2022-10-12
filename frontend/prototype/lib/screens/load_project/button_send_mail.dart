import 'package:flutter/material.dart';
import 'package:prototype/backend/value_calculator.dart';
import 'package:prototype/components/button_row_multiple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../backend/helper_objects.dart';

/// Button der die E-Mail App des Smartphones triggert
class ButtonSendMail extends StatefulWidget {
  CalculatorOutcome outcome;
  User userData;
  ButtonSendMail({required this.outcome, required this.userData});
  @override
  State<StatefulWidget> createState() {
    return _ButtonSendMailState();
  }
}

class _ButtonSendMailState extends State<ButtonSendMail> {
  /// Link, der die E-Mail App auslöst, wirft Exception, falls Link inkorrekt ist
  Future<void> _launchUrl(urlString) async {
    Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  /// Inhalt der E-Mail
  String createEmailContent(User user) {
    String body = "Guten Tag Herr Schäfer von\n Sprachtelprofi, \n \n die Ermittlung innerhalb der App " +
        "hat ergeben, dass der optimale Bedarf  für mein anstehendes Bauprojekt ${widget.outcome.material.toStringAsFixed(2)} kg" +
        " SpachtelBar® classic, sowie ${widget.outcome.edges.toStringAsFixed(2)} m Fugendeckstreifen " +
        "betragen wird. \n \n" +
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
        // E-Mail Link setzt sich aus dem Aufrau an die Mail und dem Text für die Mail zusammen
        _launchUrl("mailto:post@spachtelprofi.com?subject=$subject&body=$body");
      },
    );
  }
}
