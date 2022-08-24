import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ButtonSendMail extends StatefulWidget {
  var aiValue;
  var userData;
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

  String createEmailContent(var user) {
    String body =
        "Hallo Matthias von Spachtelprofi, \n \n Deine App hat ergeben, dass der optimale Spachtelmassenbedarf für mein anstehendes Bauprojekt " +
            widget.aiValue.toString() +
            " Liter betragen würde. Gerne würde ich in einem Gespräch mit dir genaueres darüber aushandeln. Anbei meine Kundendaten: \n \n Kundennummer: " +
            user["customerId"].toString() +
            "\n Adresse: " +
            user["address"].toString() +
            " \n \n Mit freundlichen Grüßen \n \n" +
            user["firstName"].toString() +
            " " +
            user["lastName"].toString();
    return body;
  }

  @override
  Widget build(BuildContext context) {
    String subject = "Interesse an Spachtelmasse";
    var user = widget.userData[0];
    String body = createEmailContent(user);

    return ElevatedButton(
      child: Text('E-mail senden'),
      onPressed: () {
        _launchUrl(
            "mailto:nicolas.wild@googlemail.com?subject=$subject&body=$body");
      },
    );
  }
}
