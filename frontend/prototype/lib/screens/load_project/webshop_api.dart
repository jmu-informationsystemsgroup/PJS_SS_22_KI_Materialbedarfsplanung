import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Webshop extends StatelessWidget {
  double aiValue;
  Webshop({required this.aiValue});

  Future<void> _launchUrl(urlString) async {
    Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    String subject = "Interesse an Spachtelmasse";
    String body =
        "Sehr geehrte Damen und Herren, \n \n Ihre App hat ergeben, dass der optimale Spachtelmassenbedarf für mein anstehendes Bauprojekt " +
            aiValue.toString() +
            " Liter betragen würde. Gerne würde ich in einem Gespräch mit Ihnen genaueres darüber aushandeln.\n \n Mit freundlichen Grüßen";
    return Column(
      children: [
        ElevatedButton(
          child: Text('zum Shop von Spachtelprofi'),
          onPressed: () {
            _launchUrl("https://spachtelprofi.com/shop/");
          },
        ),
        ElevatedButton(
          child: Text('Kontakt zu Spachtelprofi'),
          onPressed: () async {
            await _launchUrl(
                "mailto:nicolas.wild@googlemail.com?subject=$subject&body=$body");
          },
        )
      ],
    );
  }
}
