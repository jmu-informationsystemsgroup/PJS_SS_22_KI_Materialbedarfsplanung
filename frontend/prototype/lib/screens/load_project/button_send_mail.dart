import 'package:flutter/material.dart';
import 'package:prototype/components/button_row_multiple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../backend/helper_objects.dart';

class ButtonSendMail extends StatefulWidget {
  double aiValue;
  User userData;
  ButtonSendMail(this.aiValue, this.userData);
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
        "Hallo Matthias von Spachtelprofi, \n \n Deine App hat ergeben, dass der optimale Spachtelmassenbedarf für mein anstehendes Bauprojekt ${widget.aiValue.toStringAsFixed(2)} kg" +
            " betragen würde. Gerne würde ich in einem Gespräch mit dir genaueres darüber aushandeln. Anbei meine Kundendaten: \n \n Kundennummer: " +
            user.customerId.toString() +
            "\n Adresse: " +
            user.street.toString() +
            user.houseNumber.toString() +
            user.zip.toString() +
            user.city.toString() +
            " \n \n Mit freundlichen Grüßen \n \n" +
            user.firstName.toString() +
            " " +
            user.lastName.toString();
    return body;
  }

  @override
  Widget build(BuildContext context) {
    String subject = "Interesse an Spachtelmasse";
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
