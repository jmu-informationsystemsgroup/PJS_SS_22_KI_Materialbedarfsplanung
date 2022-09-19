import 'package:flutter/material.dart';
import 'package:prototype/components/button_edit.dart';
import 'package:prototype/components/custom_container_body.dart';
import 'package:prototype/components/icon_and_text.dart';
import 'package:prototype/screens/profile/user_data.dart';

import '../../backend/data_base_functions.dart';
import '../../backend/helper_objects.dart';
import '../../components/appBar_custom.dart';
import '../../components/custom_container_border.dart';
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
  User? user = User();
  bool textVisiblity = true;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    DataBase.getUserData().then((loadedContent) {
      if (loadedContent == null ||
          User.userToMap(loadedContent).toString() ==
              User.userToMap(user!).toString()) {
        setState(() {
          textVisiblity = false;
        });
      }
      setState(() {
        user = loadedContent;
      });
    });
  }

  bool changeBool(bool input) {
    if (input == true) {
      return false;
    } else {
      return true;
    }
  }

  addUserInformation() {
    if (user != null && user!.firstName != "" && user!.lastName != "") {
      return IconAndText(
        icon: Icons.person,
        text: "${user!.firstName} ${user!.lastName}",
        color: Colors.black,
      );
    } else {
      return Container();
    }
  }

  Widget getBody() {
    if (textVisiblity && user != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: textVisiblity,
            child: DisplayUserData(
              user: user!,
            ),
          ),
        ],
      );
    } else {
      return UserForm(
        updateValues: (data) {
          setState(() {
            user = data;
            textVisiblity = changeBool(textVisiblity);
            //  getUser();
          });
        },
        editUser: user,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScaffoldContainer(
          body: SingleChildScrollView(
            child: Column(children: [
              ButtonEdit(
                textVisiblity: textVisiblity,
                changeState: () {
                  setState(() {
                    getUser();
                    textVisiblity = changeBool(textVisiblity);
                  });
                },
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
