import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/screens/load_project/button_send_mail.dart';
import 'package:prototype/screens/profile/user_form.dart';
import 'package:prototype/screens/profile/user_data.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../backend/helper_objects.dart';
import '../../backend/value_calculator.dart';
import '../../components/button_edit.dart';
import '../../components/button_row_multiple_icons.dart';
import '../../components/custom_container_border.dart';
import '../../styles/general.dart';

class Webshop extends StatefulWidget {
  /// dies sollte ein double value sein, allerdings kann es zu ladeverzögerungen und damit
  /// zusammenhängenden Fehlermeldungen kommen
  CalculatorOutcome outcome;
  Webshop({required this.outcome});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _WebshopState();
  }
}

class _WebshopState extends State<Webshop> {
  bool mailVisability = false;
  bool textVisiblity = true;
  User user = User();
  bool userExistsVisibility = false;
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
    getUser();
  }

  bool changeBool(bool input) {
    if (input == true) {
      return false;
    } else {
      return true;
    }
  }

  IconData getIcon() {
    if (textVisiblity) {
      return Icons.edit;
    } else
      return Icons.close;
  }

  getUser() async {
    User? loadedContent = await DataBase.getUserData();

    if (loadedContent != null) {
      setState(() {
        user = loadedContent;
        userExistsVisibility = true;
      });
    } else {
      userExistsVisibility = false;
    }

    Map someMap = User.userToMap(user);

    for (var element in someMap.values) {
      if (element == "" || element == 0) {
        textVisiblity = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: mailVisability,
          child: CustomContainerBorder(
            child: Column(
              children: [
                Visibility(
                  visible: !userExistsVisibility,
                  child: Column(
                    children: [
                      Text("Bitte gib einmalig deine Userdaten an"),
                      UserForm(
                        updateValues: (data) {
                          setState(() {
                            user = data;
                            userExistsVisibility = true;
                          });
                        },
                        allValuesMandatory: true,
                        outcome: widget.outcome,
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: userExistsVisibility,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ButtonEdit(
                        textVisiblity: textVisiblity,
                        changeState: () {
                          setState(() {
                            textVisiblity = changeBool(textVisiblity);
                          });
                        },
                      ),
                      Visibility(
                        visible: textVisiblity,
                        child: Column(
                          children: [
                            DisplayUserData(user: user),
                            ButtonSendMail(
                                outcome: widget.outcome, userData: user),
                          ],
                        ),
                      ),
                      Visibility(
                        child: UserForm(
                          updateValues: (data) {
                            setState(() {
                              user = data;
                              textVisiblity = changeBool(textVisiblity);
                            });
                          },
                          outcome: widget.outcome,
                          editUser: user,
                          allValuesMandatory: true,
                        ),
                        visible: !textVisiblity,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 1,
              child: CustomButtonRow(
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: GeneralStyle.getUglyGreen(),
                  ),
                  Text(
                    "zum Webshop",
                    style: TextStyle(color: GeneralStyle.getUglyGreen()),
                  ),
                ],
                onPressed: () {
                  _launchUrl(
                      "https://spachtelprofi.com/shop/schneller-strong-spachteln-strong/verbrauchs-shy-materialien/");
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: CustomButtonRow(
                children: getMailChildren(),
                onPressed: () {
                  setState(() {
                    mailVisability = changeBool(mailVisability);
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> getMailChildren() {
    if (!mailVisability) {
      return [
        Icon(
          Icons.email_outlined,
          color: GeneralStyle.getUglyGreen(),
        ),
        Text(
          "Direkt bestellen",
          style: TextStyle(
            color: GeneralStyle.getUglyGreen(),
          ),
        ),
      ];
    } else {
      return [
        Icon(
          Icons.cancel_outlined,
          color: GeneralStyle.getUglyGreen(),
        ),
        Text(
          "Abbrechen",
          style: TextStyle(
            color: GeneralStyle.getUglyGreen(),
          ),
        ),
      ];
    }
  }
}
