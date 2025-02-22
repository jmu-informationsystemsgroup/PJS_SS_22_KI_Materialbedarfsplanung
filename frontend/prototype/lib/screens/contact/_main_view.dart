import 'package:flutter/material.dart';
import 'package:prototype/components/button_row_multiple_icons.dart';
import 'package:prototype/components/custom_container_body.dart';
import 'package:prototype/styles/container.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../components/appBar_custom.dart';
import '../../components/navBar.dart';
import '../../styles/general.dart';

class Contact extends StatelessWidget {
  String title = "Kontakt";

  Future<void> _launchUrl(urlString) async {
    Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  /// erzeugt den Anruf bzw E-Mail-Button
  Widget contactRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            _launchUrl("tel:+49-163-7774684");
          },
          child: Icon(
            Icons.add_ic_call,
            size: 50,
          ),
        ),
        GestureDetector(
          onTap: () {
            _launchUrl("mailto:post@spachtelprofi.com");
          },
          child: Icon(
            Icons.email_outlined,
            size: 50,
          ),
        ),
      ],
    );
  }

  Widget getBody() {
    return Flex(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      direction: Axis.horizontal,
      children: [
        Expanded(
            flex: 1,
            child: Container(
              margin: ContainerStyles.getMarginLeftRight(),
              child: Image.asset('assets/matthias.jpg'),
            )),
        Expanded(
          flex: 1,
          child: Container(
            margin: ContainerStyles.getMarginLeftRight(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Matthias Schäfer",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(""),
                Text("Werkzeug und Baustoffhandel"),
                Text("Simmringerstrasse 4"),
                Text("97244 Bütthard"),
                Text("Deutschland - Germany"),
                Text(""),
                contactRow(),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: CustomScaffoldContainer(
          body: Column(
            children: [
              getBody(),
              CustomButtonRow(
                children: [
                  Icon(
                    Icons.public,
                    color: GeneralStyle.getGreen(),
                  ),
                  Text(
                    "Webseite besuchen",
                    style: TextStyle(
                      color: GeneralStyle.getGreen(),
                    ),
                  ),
                ],
                onPressed: () {
                  _launchUrl("https://spachtelprofi.com/shop/");
                },
              ),
            ],
          ),
          appBar: CustomAppBar(
            title: "Spachtelprofi",
            subTitle: [Text("Ihr Experte und Ansprechpartner")],
          ),
          navBar: NavBar(3),
        ),
      ),
    );
  }
}
