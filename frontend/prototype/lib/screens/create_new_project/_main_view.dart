import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prototype/components/button_row_multiple_icons.dart';
import 'package:prototype/components/custom_container_body.dart';
import 'package:prototype/components/custom_container_border.dart';
import 'package:prototype/components/gallery.dart';
import 'package:prototype/components/navBar.dart';
import 'package:prototype/components/input_field_date.dart';
import 'package:prototype/screens/home/_main_view.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prototype/styles/general.dart';

import '../../components/appBar_custom.dart';
import '../camera/button_photo.dart';
import '../../components/icon_and_text.dart';
import '../camera/_main_view.dart';

import '../../backend/helper_objects.dart';
import '../../styles/container.dart';
import '../load_project/_main_view.dart';
import '../../components/input_field.dart';
import '../../components/input_field_address.dart';
import '../../components/checklist_quality.dart';
import '../../components/input_walls.dart';

class NewProject extends StatefulWidget {
  String title = "Neues Projekt";
  // instanzieeren eines Contentobjekts, in dem sämtliche Eingabeinformationen zwischengespeichert werden
  static var cache = Content();
  static List<XFile?> images = [];

  /// verbindet zur Projektansicht, wenn das neu erstellte Projekt gespeichert wird
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
  List<Wall> walls = [];
  int state = 0;
  Content content = NewProject.cache;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    walls = NewProject.cache.walls;
    galleryPictures = NewProject.cache.pictures;
  }

// Überbleibsel-Dialog vom Image-Picker
/*
  Future<void> _showMyDialog() async {
    if (NewProject.askAgain) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Kamera einstellen'),
            content: SingleChildScrollView(
              child: ListView(
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
  */

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

  Future<void> _askForImageDelete(CustomCameraImage element) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: IconAndText(
            icon: Icons.delete,
            text: "Wirklich löschen",
          ),
          content: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  margin: ContainerStyles.getMarginLeftRight(),
                  child: Image.file(
                    File(element.image.path),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  margin: ContainerStyles.getMarginLeftRight(),
                  child: Text(
                      'Soll das Bild Nr. ${element.id} wirklich gelöscht werden?'),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: IconAndText(
                  icon: Icons.cancel,
                  text: "Abbrechen",
                  color: GeneralStyle.getGreen()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: IconAndText(
                icon: Icons.delete,
                text: "Löschen",
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  element.display = false;
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _askForProjectCancellation() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: IconAndText(
            icon: Icons.delete,
            text: "Wirklich abbrechen?",
          ),
          actions: <Widget>[
            TextButton(
              child: IconAndText(
                icon: Icons.cancel,
                text: "Verwerfen",
                color: Colors.red,
              ),
              onPressed: () {
                NewProject.cache = Content();
                content = Content();
                galleryPictures = [];

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            TextButton(
              child: IconAndText(
                  icon: Icons.check,
                  text: "Weitermachen",
                  color: GeneralStyle.getGreen()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _askForSaveEmptyProject() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: IconAndText(
            icon: Icons.delete,
            text: "Wirklich speichern?",
          ),
          content: Text(
              "Das Projekt enthält weder Daten noch Bilder, wirklich speichern?"),
          actions: <Widget>[
            TextButton(
              child: IconAndText(
                icon: Icons.cancel,
                text: "Abbrechen",
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: IconAndText(
                  icon: Icons.check,
                  text: "Speichern",
                  color: GeneralStyle.getGreen()),
              onPressed: () async {
                var save = await savingProcess();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScaffoldContainer(
          appBar: CustomAppBar(
            title: "Neues Projekt",
            subTitle: [
              IconAndText(
                text: "Kunde: ${content.client}",
                icon: Icons.person_pin_circle_outlined,
                color: Colors.black,
              ),
              IconAndText(
                text:
                    "Adresse: ${content.street} ${content.houseNumber} ${content.zip} ${content.city}",
                icon: Icons.location_on_outlined,
                color: Colors.black,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Form(
              child: Column(
                children: <Widget>[
                  InputField(
                    saveTo: (text) => {
                      setState(() {
                        NewProject.cache.projectName = text;
                        content.projectName = text;
                      }),
                    },
                    labelText: "Projektname",
                    icon: Icons.discount_outlined,
                    value: content.projectName,
                  ),
                  Center(
                    child: Text(
                      "Erinnerung: Nur ein Foto pro Wand",
                      style: TextStyle(
                        color: GeneralStyle.getLightGray(),
                      ),
                    ),
                  ),
                  // Fotobutton um Kameraansicht zu öffnen
                  Center(
                    child: ButtonPhoto(
                      addPhoto: () async {
                        await availableCameras().then(
                          (value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CameraPage(
                                cameras: value,
                                originalGallery: galleryPictures,
                                updateGallery: (images) {
                                  setState(() {
                                    NewProject.cache.pictures.addAll(images);
                                    galleryPictures = NewProject.cache.pictures;
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
/*
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
*/
                  Gallery(
                    pictures: galleryPictures,
                    deleteFunction: (element) {
                      _askForImageDelete(element);
                    },
                    //  creationMode: true,
                  ),
                  InputWalls(
                    input: walls,
                    updateValues: (outputWalls) {
                      setState(() {
                        NewProject.cache.walls = outputWalls;
                        walls = outputWalls;
                      });
                    },
                  ),

                  InputField(
                    saveTo: (text) => {
                      setState(() {
                        NewProject.cache.client = text;
                        content.client = text;
                      }),
                    },
                    labelText: "Kunde",
                    icon: Icons.person_pin_circle_outlined,
                    value: content.client,
                  ),
                  InputDate(
                    saveTo: (text) => {
                      NewProject.cache.date = text,
                      content.date = text,
                    },
                    value: content.date,
                  ),
                  AddressInput(
                    updateAddress: (value) {
                      NewProject.cache.street = value.street;
                      NewProject.cache.houseNumber = value.houseNumber;
                      NewProject.cache.zip = value.zip;
                      NewProject.cache.city = value.city;
                      setState(() {
                        content.street = value.street;
                        content.houseNumber = value.houseNumber;
                        content.zip = value.zip;
                        content.city = value.city;
                      });
                    },
                    adress: Adress(
                      street: content.street,
                      houseNumber: content.houseNumber,
                      zip: content.zip,
                      city: content.city,
                    ),
                  ),
                  InputField(
                    saveTo: (text) => {
                      NewProject.cache.comment = text,
                      content.comment = text,
                    },
                    value: content.comment,
                    labelText: "Kommentar",
                    maxLines: 6,
                  ),

                  QualityChecklist(
                    changeQuality: (qualitString) => {
                      NewProject.cache.material = qualitString,
                      content.material = qualitString,
                    },
                    value: content.material,
                  ),
                  //    preview(),
                  Visibility(
                    child: Text("wird gespeichert ($state %)"),
                    visible: showState,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CustomButtonRow(
                            colorOutlined: Colors.black,
                            children: [
                              Icon(Icons.delete_outline, color: Colors.red),
                              Text("Verwerfen",
                                  style: TextStyle(color: Colors.red))
                            ],
                            //   color: Colors.red,
                            onPressed: () {
                              _askForProjectCancellation();
                            }),
                      ),
                      Expanded(
                        flex: 1,
                        child: CustomButtonRow(
                          colorOutlined: Colors.black,
                          children: [
                            Icon(Icons.save_outlined,
                                color: GeneralStyle.getGreen()),
                            Text(
                              'Speichern',
                              style: TextStyle(
                                color: GeneralStyle.getGreen(),
                              ),
                            ),
                          ],
                          onPressed: () async {
                            Content emptyContent = Content();
                            // testet ob der Nutzer ein leeres Projekt speichern will
                            if (Content.contentToMap(content).toString() ==
                                    Content.contentToMap(emptyContent)
                                        .toString() &&
                                galleryPictures.toString() == [].toString() &&
                                walls.toString() == [].toString()) {
                              _askForSaveEmptyProject();
                            } else {
                              var save = await savingProcess();
                            }
                          },
                        ),
                      ),
                    ],
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

  savingProcess() async {
    //    Content.reset(NewProject.cash);
    setState(() {
      showState = true;
    });

    NewProject.cache.pictures
        .removeWhere((element) => element.display == false);

    projectId = await DataBase.createNewProject(NewProject.cache);

    bool wallsComplete =
        await DataBase.createWallsForProject(NewProject.cache.walls, projectId);

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
  }
}
