import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/screens/load_project/button_send_mail.dart';
import 'package:prototype/screens/load_project/user_form.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../backend/helper_objects.dart';
import '../../components/button_multiple_icons.dart';
import '../../components/custom_container_white.dart';

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
  bool mailVisability = false;
  bool textVisiblity = true;
  bool editorVisiblity = false;
  bool userExistsVisibility = false;
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

  bool changeBool(bool input) {
    if (input == true) {
      return false;
    } else {
      return true;
    }
  }

  Icon getIcon() {
    if (textVisiblity) {
      return Icon(Icons.edit);
    } else
      return Icon(Icons.close);
  }

  activateList() async {
    DataBase.getUserData().then((loadedContent) {
      setState(() {
        userData = loadedContent;
      });
    });
  }

  Map<String, dynamic> userDataNullCheckSafe() {
    if (userData.isNotEmpty) {
      return userData[0];
    }
    return User.emptyUser;
  }

  @override
  Widget build(BuildContext context) {
    User user = User.mapToUser(User.emptyUser);
    if (userData.isNotEmpty) {
      userExistsVisibility = true;
      user = User.mapToUser(userData[0]);
    }
    return Column(
      children: [
        CustomButton(
          children: [
            Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            Icon(
              Icons.public,
              color: Colors.white,
            ),
          ],
          onPressed: () {
            _launchUrl("https://spachtelprofi.com/shop/");
          },
        ),
        CustomButton(
          children: [
            Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            Icon(
              Icons.mail,
              color: Colors.white,
            )
          ],
          onPressed: () {
            setState(() {
              mailVisability = true;
            });
          },
        ),
        Visibility(
          visible: mailVisability,
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
                          userData = data;
                          user = User.mapToUser(data[0]);
                          userExistsVisibility = true;
                        });
                      },
                      aiValue: widget.aiValue,
                    )
                  ],
                ),
              ),
              Visibility(
                visible: userExistsVisibility,
                child: CustomContainerWhite(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: textVisiblity,
                        child: Text(
                          "Bitte Daten kontrollieren: \nName: " +
                              user.firstName.toString() +
                              " " +
                              user.lastName.toString() +
                              "\nKundennummer: " +
                              user.customerId.toString() +
                              "\nAdresse: " +
                              user.address.toString(),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            editorVisiblity = changeBool(editorVisiblity);
                            textVisiblity = changeBool(textVisiblity);
                          });
                        },
                        child: getIcon(),
                      ),
                      Visibility(
                        child: UserForm(
                          updateValues: (data) {
                            setState(() {
                              userData = data;
                              editorVisiblity = changeBool(editorVisiblity);
                              textVisiblity = changeBool(textVisiblity);
                            });
                          },
                          aiValue: widget.aiValue,
                          editUser: userDataNullCheckSafe(),
                        ),
                        visible: editorVisiblity,
                      ),
                      ButtonSendMail(widget.aiValue, userData),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
