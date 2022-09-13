import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prototype/components/button_row_multiple_icons.dart';
import 'package:prototype/components/custom_container_body.dart';
import 'package:prototype/components/gallery.dart';
import 'package:prototype/components/navBar.dart';
import 'package:prototype/components/input_field_date.dart';
import 'package:prototype/screens/home/_main_view.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prototype/styles/general.dart';

import '../../components/appBar_custom.dart';
import '../../components/icon_and_text.dart';
import '../../components/screen_camera.dart';

import '../../backend/helper_objects.dart';
import '../load_project/_main_view.dart';
import '../../components/input_field.dart';
import 'input_field_address.dart';
import 'checklist_quality.dart';
import 'mvp_walls.dart';

class NewProject extends StatefulWidget {
  String title = "Neues Projekt";
  // instanzieeren eines Contentobjekts, in dem sämtliche EIngabeinformationen zwischengespeichert werden
  static var cache = Content();
  static List<XFile?> images = [];
  static bool askAgain = true;

  static goToProjectView(int id, context) async {
    await Future.delayed(Duration(seconds: 1));
    Content link = await DataBase.getSpecificProject(id);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => ProjectView(link)),
      (Route<dynamic> route) => false,
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _NewProjectState();
  }
}

class _NewProjectState extends State<NewProject> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var showState = false;
  int projectId = 0;
  List<CustomCameraImage> galleryPictures = [];
  int state = 0;
  String street = "";
  String houseNumber = "";
  String zip = "";
  String city = "";
  String projectName = "";
  String client = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    galleryPictures = NewProject.cache.pictures;
    street = NewProject.cache.street;
    houseNumber = NewProject.cache.houseNumber;
    zip = NewProject.cache.zip;
    city = NewProject.cache.city;
    projectName = NewProject.cache.projectName;
    client = NewProject.cache.client;
  }

  Future<void> _showMyDialog() async {
    if (NewProject.askAgain) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Kamera einstellen'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Row(children: [
                    Icon(Icons.stay_current_portrait),
                    Icon(Icons.screen_rotation),
                    Icon(Icons.stay_current_landscape)
                  ]),
                  Text('Kameraeinstellung auf 4:3'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Approve'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    NewProject.askAgain = false;
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }

/*
  Widget preview() {
    Row row = Row(
      children: [],
    );

    if (NewProject.cash.pictures.isNotEmpty) {
      for (var picture in NewProject.cash.pictures) {
        print(picture.toString() +
            "--------------------------------------------------------------");
        row.children.add(Image.file(
          File(picture!.path),
          width: 50,
        ));
      }
    }
    return row;
  }
  
  */

  goBack() async {
    await Future.delayed(Duration(seconds: 1));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><${NewProject.askAgain}");
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: CustomScaffoldContainer(
          appBar: CustomAppBar(
            title: "Neues Projekt",
            subTitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconAndText(
                  text: "Aufttraggeber: $client",
                  icon: Icons.person_pin_circle_outlined,
                  color: Colors.black,
                ),
                IconAndText(
                  text: "Adresse: $street $houseNumber $zip $city",
                  icon: Icons.location_on_outlined,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Form(
              child: Column(
                children: <Widget>[
                  InputField(
                    saveTo: (text) => {
                      NewProject.cache.projectName = text,
                      projectName = text
                    },
                    labelText: "Name",
                    value: projectName,
                  ),

                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await availableCameras().then((value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CameraPage(
                                        cameras: value,
                                        originalGallery: galleryPictures,
                                        updateGallery: (images) {
                                          setState(() {
                                            NewProject.cache.pictures
                                                .addAll(images);
                                            galleryPictures =
                                                NewProject.cache.pictures;
                                          });
                                        },
                                      )),
                            ));
                      },
                      child: Icon(Icons.camera_alt),
                    ),
                  ),

                  Center(
                      child: CustomButtonRow(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: GeneralStyle.getUglyGreen(),
                      ),
                      Text(
                        "Picker",
                        style: TextStyle(
                          color: GeneralStyle.getUglyGreen(),
                        ),
                      ),
                    ],
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      var dialog = await _showMyDialog();
                      // Pick an image

                      final XFile? image = await _picker.pickImage(
                          source: ImageSource.camera,
                          maxWidth: 400,
                          maxHeight: 300);
                      if (image != null) {
                        setState(
                          () {
                            NewProject.cache.pictures.add(CustomCameraImage(
                                id: galleryPictures.last.id + 1, image: image));
                            galleryPictures = NewProject.cache.pictures;
                          },
                        );
                      }
                    },
                  )),

                  Gallery(
                    pictures: galleryPictures,
                    deleteFunction: (element) {
                      setState(() {
                        element.display = false;
                      });
                    },
                    //  creationMode: true,
                  ),
                  InputField(
                    saveTo: (text) =>
                        {NewProject.cache.client = text, client = text},
                    labelText: "Auftraggeber",
                    value: client,
                  ),
                  InputDate(
                    saveTo: (text) => {NewProject.cache.date = text},
                  ),
                  AddressInput(
                    updateAddress: (value) {
                      NewProject.cache.street = value.street;
                      NewProject.cache.houseNumber = value.houseNumber;
                      NewProject.cache.zip = value.zip;
                      NewProject.cache.city = value.city;
                      setState(() {
                        street = value.street;
                        houseNumber = value.houseNumber;
                        zip = value.zip;
                        city = value.city;
                      });
                    },
                  ),
                  InputField(
                    saveTo: (text) => {NewProject.cache.comment = text},
                    labelText: "Kommentar",
                    maxLines: 6,
                  ),
                  // MVPWalls(),
                  QualityChecklist(
                    changeQuality: (qualitString) => {
                      NewProject.cache.material = qualitString,
                    },
                  ),
                  //    preview(),
                  Visibility(
                    child: Text("wird gespeichert ($state %)"),
                    visible: showState,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      child: const Text('Projekt speichern und berechnen'),
                      onPressed: () async {
                        //    Content.reset(NewProject.cash);
                        setState(() {
                          showState = true;
                        });

                        NewProject.cache.pictures
                            .removeWhere((element) => element.display == false);

                        projectId =
                            await DataBase.createNewProject(NewProject.cache);

                        bool imagesComplete = await DataBase.saveImages(
                            pictures: NewProject.cache.pictures,
                            projectId: projectId,
                            updateState: (value) {
                              setState(() {
                                state = value;
                              });
                            });

                        NewProject.cache = Content(); //reset
                        NewProject.goToProjectView(projectId, context);

                        // goBack();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          navBar: NavBar(1),
        ),
      ),
    );
  }
}
