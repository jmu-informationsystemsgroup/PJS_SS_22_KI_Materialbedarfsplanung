import 'package:flutter/material.dart';
import 'package:prototype/components/custom_container_body.dart';
import 'package:prototype/components/icon_and_text.dart';
import 'package:prototype/screens/profile/user_data.dart';

import '../../backend/data_base_functions.dart';
import '../../backend/helper_objects.dart';
import '../../components/appBar_custom.dart';
import '../../components/custom_container_white.dart';
import '../../components/navBar.dart';
import '../../styles/general.dart';
import 'user_form.dart';

class Profile extends StatefulWidget {
  String title = "Profil";

  _ProfileState createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  List userData = [];
  User user = User();
  bool textVisiblity = true;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    DataBase.getUserData().then(
      (loadedContent) {
        setState(() {
          userData = loadedContent;
        });
        if (userData.isNotEmpty) {
          setState(() {
            user = User.mapToUser(userData[0]);
          });
        }
      },
    );
  }

  IconData getIcon() {
    if (textVisiblity) {
      return Icons.edit;
    } else
      return Icons.close;
  }

  bool changeBool(bool input) {
    if (input == true) {
      return false;
    } else {
      return true;
    }
  }

  Map<String, dynamic> userDataNullCheckSafe() {
    if (userData.isNotEmpty) {
      return userData[0];
    }
    return User.emptyUser;
  }

  addUserInformation() {
    if (userData.isNotEmpty) {
      return IconAndText(
        icon: Icons.person,
        text: "${user.firstName} ${user.lastName}",
        color: Colors.black,
      );
    } else {
      return Container();
    }
  }

  Widget getBody() {
    if (userData.isNotEmpty && textVisiblity) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: textVisiblity,
            child: DisplayUserData(
              user: User.mapToUser(userData[0]),
            ),
          ),
        ],
      );
    } else {
      return UserForm(
        updateValues: (data) {
          setState(() {
            userData = data;
            textVisiblity = changeBool(textVisiblity);
            //  getUser();
          });
        },
        editUser: userDataNullCheckSafe(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: CustomScaffoldContainer(
          body: SingleChildScrollView(
            child: Column(children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 2.0,
                          color: GeneralStyle.getDarkGray(),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Icon(
                      getIcon(),
                      color: GeneralStyle.getDarkGray(),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      textVisiblity = changeBool(textVisiblity);
                    });
                  },
                ),
              ),
              getBody()
            ]),
          ),
          appBar: CustomAppBar(
            title: "Mein Profil",
            subTitle: [
              addUserInformation(),
            ],
          ),
          navBar: NavBar(2),
        ),
      ),
    );
  }
}
