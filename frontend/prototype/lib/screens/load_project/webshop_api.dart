import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/screens/load_project/button_send_mail.dart';
import 'package:prototype/screens/load_project/create_new_user.dart';
import 'package:url_launcher/url_launcher.dart';

class Webshop extends StatefulWidget {
  /// dies sollte ein double value sein, allerdings kann es zu ladeverzögerungen und damit
  /// zusammenhängenden Fehlermeldungen kommen
  var aiValue;
  Webshop({required this.aiValue});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _WebshopState();
  }
}

class _WebshopState extends State<Webshop> {
  bool visability = false;
  List userData = [];
//  User user = User();
  Future<void> _launchUrl(urlString) async {
    Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    activateList();
  }

  activateList() async {
    DataBase.getUserData().then((loadedContent) {
      setState(() {
        userData = loadedContent;
      });
    });
  }

  Widget chooseWidget() {
    Column column = Column(
      children: [],
    );

    if (userData.isEmpty) {
      column.children.add(
        Text("Bitte gib einmalig deine Userdaten an"),
      );
      column.children.add(CreateUser(
        aiValue: widget.aiValue,
        updateValues: () {
          activateList();
        },
      ));
    } else {
      var user = userData[0];
      column.children.add(
        Text(
          "Bitte Daten kontrollieren: Name: " +
              user["firstName"].toString() +
              " " +
              user["lastName"].toString() +
              ", Kundennummer: " +
              user["customerId"].toString() +
              " Adresse: " +
              user["address"].toString(),
        ),
      );
      column.children.add(ButtonSendMail(widget.aiValue, userData));
    }

    return column;
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {
            setState(() {
              visability = true;
            });
          },
        ),
        Visibility(
          child: chooseWidget(),
          visible: visability,
        )
      ],
    );
  }
}
