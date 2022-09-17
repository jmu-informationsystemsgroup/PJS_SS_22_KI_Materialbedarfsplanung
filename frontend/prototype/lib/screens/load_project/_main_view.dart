import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/button_edit.dart';
import 'package:prototype/components/button_row_multiple_icons.dart';
import 'package:prototype/components/custom_container_white.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';
import 'package:prototype/components/input_field_address.dart';
import 'package:prototype/screens/home/_main_view.dart';
import 'package:prototype/screens/load_project/container_all_data.dart';
import 'package:prototype/screens/load_project/dashboard.dart';
import 'package:prototype/screens/load_project/editor.dart';
import 'package:prototype/components/gallery.dart';
import 'package:prototype/components/navBar.dart';
import 'package:prototype/screens/load_project/projectMap.dart';
import 'package:prototype/screens/load_project/webshop_api.dart';
import 'package:camera/camera.dart';
import 'package:prototype/styles/container.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../backend/server_ai.dart';
import '../../components/appBar_custom.dart';
import '../../components/custom_container_body.dart';
import '../../components/icon_and_text.dart';
import '../../components/screen_camera.dart';
import '../../backend/value_calculator.dart';
import 'package:prototype/backend/data_base_functions.dart';

import '../../styles/general.dart';

class ProjectView extends StatefulWidget {
  Content content;
  ProjectView(this.content);
  static bool askAgain = true;

  @override
  _ProjectViewState createState() {
    return _ProjectViewState();
  }
}

class _ProjectViewState extends State<ProjectView> {
  CalculatorOutcome calculatedOutcome = CalculatorOutcome();
  bool editorVisablity = false;
  Content content = Content();

  /// eine Liste sämtlicher Bildobjekte zu dem Projekt
  List<CustomCameraImage> galleryImages = [];

  /// eine Liste aller Bilder zu denen noch kein KI Ergebnis vorliegt
  List<CustomCameraImage> galleryImagesNotYetCalculated = [];

  /// eine Liste aller Bilder zu denen es fehlerhafte KI Werte gibt und zu denen
  /// der Nutzer aufgewfordert wird, sie zu löschen
  List<CustomCameraImage> galleryImagesToDelete = [];

  /// gibt den Ladestatus, wenn entweder der KI Wert zu einem Bild ermittelt wird
  /// oder aber ein Bild gerade gespeichert wird
  int state = 0;

  /// wenn true: verhindert dass veraltete KI-Werte angezeigt werden
  bool recalculate = false;

  /// wenn true: sorgt dafür dass ein Speicherstatus zu den zu verarbeitenden Bildern
  /// angezeigt wird
  bool safingImages = false;

  /// wichtig für das Speichern neu hinzugefügter Bilder: gibt an unter welcher id das
  /// neuhinzugefügt Bild gespeichert werden kann und zählt dann hoch
  int originalLastValue = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    content = widget.content;
    loadGalleryPictures();
  }

  loadGalleryPictures() async {
    galleryImagesNotYetCalculated =
        await DataBase.getImages(projectId: content.id, onlyNewImages: true);
    galleryImagesToDelete =
        await DataBase.getImages(projectId: content.id, onlyNewImages: true);
    List<CustomCameraImage> saveState =
        await DataBase.getImages(projectId: content.id);
    CalculatorOutcome val =
        await ValueCalculator.getOutcomeObject(content, saveState);
    if (saveState.isNotEmpty) {
      originalLastValue = saveState.last.id;
    }

    setState(() {
      galleryImages = saveState;
      calculatedOutcome = val;
    });
  }

  Future<void> _showMyDialog() async {
    if (ProjectView.askAgain) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Kamera eisntellen'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Row(
                    children: [
                      Icon(Icons.stay_current_portrait),
                      Icon(Icons.screen_rotation),
                      Icon(Icons.stay_current_landscape),
                    ],
                  ),
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
                    ProjectView.askAgain = false;
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }

  bool changeBool(bool input) {
    if (input == false) {
      return true;
    } else {
      return false;
    }
  }

  Widget renderArchiveButton(int id) {
    if (content.statusActive == 0) {
      return CustomButtonRow(
        onPressed: () {
          DataBase.activateProject(id);
        },
        children: [
          Icon(Icons.settings_backup_restore),
          Text("Projekt reaktivieren")
        ],
      );
    } else {
      return CustomButtonRow(
        onPressed: () {
          DataBase.archieveProject(id);
        },
        children: [
          Icon(Icons.emoji_events_outlined),
          Text("Projekt abgeschlossen")
        ],
      );
    }
  }

  Future<void> _launchMapsLink() async {
    String urlString =
        "https://www.google.com/maps/place/${content.street}+${content.houseNumber},+${content.zip}+${content.city}";
    Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  Widget comment() {
    return CustomContainerBorder(
      color: GeneralStyle.getLightGray(),
      child: Column(
        //  crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Kommentar:",
            style: TextStyle(
              color: GeneralStyle.getLightGray(),
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(content.comment),
        ],
      ),
    );
  }

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
                  color: GeneralStyle.getUglyGreen()),
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
                deleteImageAction(element);
              },
            ),
          ],
        );
      },
    );
  }

  deleteImageAction(CustomCameraImage element) async {
    setState(() {
      element.display = false;
    });
    var sh = await DataBase.deleteSingleImageFromTable(content.id, element.id);
    var sh2 =
        await DataBase.deleteSingleImageFromDirectory(content.id, element.id);
    loadGalleryPictures();
  }

  addPhoto() async {
    await availableCameras().then(
      (value) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraPage(
            cameras: value,
            originalGallery: galleryImages,
            updateGallery: (images) async {
              setState(
                () {
                  galleryImages.addAll(images);
                  calculatedOutcome.aiOutcome = 0.0;
                },
              );
              bool sth = await DataBase.saveImages(
                pictures: images,
                startId: originalLastValue + 1,
                projectId: content.id,
                updateState: (val) {
                  setState(() {
                    safingImages = true;
                    state = val;
                  });
                },
              );
              state = 0;
              safingImages = false;
              loadGalleryPictures();
            },
          ),
        ),
      ),
    );
  }

  Widget addPhotoButton() {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: CustomButtonRow(
        children: [
          Icon(
            Icons.add_a_photo_outlined,
          ),
        ],
        onPressed: () {
          addPhoto();
        },
      ),
    );
  }

  Future<void> _askForProjectDelete() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: IconAndText(
            icon: Icons.delete,
            text: "Wirklich löschen",
          ),
          content: Text('Projekt "${content.projectName}" wirklich löschen?'),
          actions: <Widget>[
            TextButton(
              child: IconAndText(
                  icon: Icons.cancel,
                  text: "Abbrechen",
                  color: GeneralStyle.getUglyGreen()),
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
                DataBase.deleteProject(content.id);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget getClientForHeader() {
    if (content.client != "") {
      return IconAndText(
        text: "${content.client}",
        icon: Icons.person_pin_circle_outlined,
        color: Colors.black,
      );
    } else {
      return Container();
    }
  }

  Widget getAdressForHeader() {
    if (content.street != "" && content.zip != "" && content.city != "") {
      return GestureDetector(
        onTap: () {
          _launchMapsLink();
        },
        child: IconAndText(
          text:
              "${content.street} ${content.houseNumber} ${content.zip} ${content.city}",
          icon: Icons.location_on_outlined,
          color: Colors.black,
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>last value: $originalLastValue");
    return Scaffold(
      body: CustomScaffoldContainer(
        appBar: CustomAppBar(
          title: content.projectName,
          subTitle: [getClientForHeader(), getAdressForHeader()],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              /*
              Center(
                child: ProjectMap(
                  adress: Adress(
                      street: content.street,
                      houseNumber: content.houseNumber,
                      city: content.city,
                      zip: content.zip),
                ),
              ),
              */
              ButtonEdit(
                textVisiblity: !editorVisablity,
                changeState: () {
                  setState(() {
                    editorVisablity = changeBool(editorVisablity);
                  });
                },
              ),
              Visibility(
                visible: editorVisablity,
                child: CustomContainerBorder(
                  child: EditorWidget(
                    input: content,
                    route: ((data) {
                      setState(() {
                        content = data;
                        editorVisablity = false;
                      });
                      loadGalleryPictures();
                    }),
                  ),
                ),
              ),
              Dashboard(
                content: content,
                imagesToDelete: galleryImagesToDelete,
                addPhoto: () {
                  addPhoto();
                },
                recalculate: recalculate,
                outcome: calculatedOutcome,
                galleryImages: galleryImages,
                state: state,
                deleteFunction: (element) {
                  _askForImageDelete(element);
                },
                updateImages: () async {
                  setState(() {
                    state = 0;
                    recalculate = true;
                  });
                  List<CustomCameraImage> replaceList = [];
                  if (galleryImagesNotYetCalculated.isNotEmpty) {
                    replaceList = await ServerAI.getAiValuesFromServer(
                        galleryImagesNotYetCalculated, (value) {
                      setState(() {
                        state = value;
                      });
                    });
                    setState(() {
                      recalculate = false;
                    });
                  }
                  loadGalleryPictures();
                },
              ),
              Webshop(
                aiValue: calculatedOutcome.aiOutcome,
              ),
              comment(),

              /*
            Text("Quadratmeter: " +
                    calculatedOutcome["totalSquareMeters"].toString()),
           Text("Preis: " + calculatedOutcome["totalPrice"].toString()),
*/
              Container(
                margin: const EdgeInsets.all(10.0),
              ),
              CustomContainerBorder(
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Gallery(
                        pictures: galleryImages,
                        deleteFunction: (element) {
                          _askForImageDelete(element);
                        },
                      ),
                    ),
                    Expanded(flex: 4, child: addPhotoButton()),
                  ],
                ),
              ),

/*
          CustomButton(
            children: const [
              Icon(
                Icons.add,
                color: Colors.white,
              ),
              Icon(
                Icons.image,
                color: Colors.white,
              ),
              Text(
                "Imagepicker",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
            onPressed: () async {
              final ImagePicker _picker = ImagePicker();
              var dialog = await _showMyDialog();
              // Pick an image

              final XFile? image = await _picker.pickImage(
                  source: ImageSource.camera, maxWidth: 400, maxHeight: 300);
              if (image != null) {
                setState(
                  () {
                    addedPictures.add(image);
                    galleryPictures.add(image);
                    safeNewPicturesButton = true;
                  },
                );
              }
            },
          ),
          */

              Visibility(
                visible: safingImages,
                child: Text("Speichere Bilder $state %"),
              ),
              Visibility(
                visible: !editorVisablity,
                child: AllData(content: content),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(5.0),
                      child: CustomButtonRow(
                        onPressed: () {
                          _askForProjectDelete();
                        },
                        children: [
                          Icon(Icons.delete_outline),
                          Text("Projekt löschen")
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(5.0),
                      child: renderArchiveButton(content.id),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        navBar: NavBar(99),
      ),
    );
  }
}
