import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/screens/load_project/button_send_mail.dart';
import 'package:prototype/screens/load_project/user_form.dart';
import 'package:prototype/screens/profile/user_data.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../backend/helper_objects.dart';
import '../../components/button_row_multiple_icons.dart';
import '../../components/custom_container_white.dart';
import '../../styles/general.dart';

class Webshop extends StatefulWidget {
  /// dies sollte ein double value sein, allerdings kann es zu ladeverzögerungen und damit
  /// zusammenhängenden Fehlermeldungen kommen
  double aiValue;
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
    getUser();
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

  getUser() async {
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
      Map someMap = userData[0];
      userExistsVisibility = true;
      someMap.values.forEach((element) {
        if (element == "" || element == 0) {
          userExistsVisibility = false;
        }
      });
      user = User.mapToUser(userData[0]);
    }
    return Column(
      children: [
        CustomButtonRow(
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              color: GeneralStyle.getUglyGreen(),
            ),
            Text(
              "Zum Webshop",
              style: TextStyle(color: GeneralStyle.getUglyGreen()),
            ),
          ],
          onPressed: () {
            _launchUrl("https://spachtelprofi.com/shop/");
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
                      allValuesMandatory: true,
                      editUser: userDataNullCheckSafe(),
                      aiValue: widget.aiValue,
                    )
                  ],
                ),
              ),
              Visibility(
                visible: userExistsVisibility,
                child: CustomContainerBorder(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: textVisiblity,
                        child: DisplayUserData(
                          user: user,
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
                          allValuesMandatory: true,
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
        ),
        CustomButtonRow(
          children: [
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
          ],
          onPressed: () {
            setState(() {
              mailVisability = true;
            });
          },
        ),
      ],
    );
  }
}
