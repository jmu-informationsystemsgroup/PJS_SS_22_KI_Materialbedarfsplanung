import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/button_edit.dart';
import 'package:prototype/components/button_row_multiple_icons.dart';
import 'package:prototype/components/custom_container_border.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';
import 'package:prototype/components/input_field_address.dart';
import 'package:prototype/screens/home/_main_view.dart';
import 'package:prototype/screens/load_project/container_all_data.dart';
import 'package:prototype/screens/load_project/dashboard.dart';
import 'package:prototype/screens/load_project/editor.dart';
import 'package:prototype/components/gallery.dart';
import 'package:prototype/components/navBar.dart';
import 'package:prototype/screens/load_project/walls.dart';
import 'package:prototype/screens/load_project/webshop_api.dart';
import 'package:camera/camera.dart';
import 'package:prototype/styles/container.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../backend/server_ai.dart';
import '../../components/appBar_custom.dart';
import '../../components/custom_container_body.dart';
import '../../components/icon_and_text.dart';
import '../../screens/camera/_main_view.dart';
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

  /// eine Liste sämtlicher Bildobjekte des Projekts
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

  List<Wall> walls = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    content = widget.content;
    setUpAssets();
  }

  /// Lädt Fotos und manuell eingegebene Flächen in das Projekt und löst die Kalkulationsmethode aus
  setUpAssets() async {
    galleryImagesNotYetCalculated =
        await DataBase.getImages(projectId: content.id, onlyNewImages: true);
    galleryImagesToDelete = await DataBase.getImages(
        projectId: content.id, deletetableImages: true);
    List<CustomCameraImage> saveState =
        await DataBase.getImages(projectId: content.id);
    List<Wall> saveWalls = await DataBase.getWalls(content.id);

    CalculatorOutcome val = ValueCalculator.calculate(
        content: content, images: saveState, walls: saveWalls);
    if (saveState.isNotEmpty) {
      originalLastValue = saveState.last.id;
    }

    /// der Umweg mit der Deklaration einer neuen Liste (wie saveWalls) muss gemacht werden, da
    /// flutter sonst nicht in der Lage ist zu erkennen, dass sich die Liste geändert hat
    /// setState((){List.add(object)}) würde also keine Veränderung hervorrufen
    setState(() {
      walls = saveWalls;
      galleryImages = saveState;
      calculatedOutcome = val;
    });
  }

  /// Dialog der ausgelöst wird, wenn die Verbindung zum Server fehlschlägt
  Future<void> _ServerMessage() async {
    if (ProjectView.askAgain) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Verbindung verloren'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Icon(
                          Icons.satellite_alt_outlined,
                          color: GeneralStyle.getDarkGray(),
                          size: 50,
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                            "Das Gerät konnte leider keine Verbindung zum Server herstellen. " +
                                "Stelle bitte eine zuverlässige Verbindung zum Internet her (WLAN oder 2G+) und versuche es erneut."),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Verstanden'),
                onPressed: () {
                  Navigator.of(context).pop();
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

  /// Button fpr Projekt abschließen, wechselt zu "Projekt reaktivieren"-Button wenn Projekt abgeschlossen
  /// ist
  Widget renderArchiveButton(int id) {
    if (content.statusActive == 0) {
      return CustomButtonRow(
        onPressed: () async {
          await DataBase.activateProject(id);
          setState(() {
            content.statusActive = 1;
          });
        },
        children: [
          Icon(Icons.settings_backup_restore),
          Text("Projekt reaktivieren")
        ],
      );
    } else {
      return CustomButtonRow(
        onPressed: () async {
          await DataBase.archieveProject(id);
          setState(() {
            content.statusActive = 0;
          });
        },
        children: [
          Icon(Icons.emoji_events_outlined),
          Text("Projekt abgeschlossen")
        ],
      );
    }
  }

  /// baut einen GoogleMaps-Link aus der eingegebenen Adresse zusammen
  Future<void> _launchMapsLink() async {
    String urlString =
        "https://www.google.com/maps/place/${content.street}+${content.houseNumber},+${content.zip}+${content.city}";
    Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  /// Widget für hellgraue Kommentar-Anzeige
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

  /// Dialog, der erscheint, wenn Foto gelöscht wird
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
                deleteImageAction(element);
              },
            ),
          ],
        );
      },
    );
  }

  /// macht das zu löschende Bild in der
  deleteImageAction(CustomCameraImage element) async {
    setState(() {
      element.display = false;
    });
    var sh = await DataBase.deleteSingleImageFromTable(content.id, element.id);
    var sh2 =
        await DataBase.deleteSingleImageFromDirectory(content.id, element.id);
    setUpAssets();
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
              // fügt die neuen Fotos der Gallerie hinzu, setzt das Ergebnis auf 0.0 um so den KI-Status
              // auf Neu-Synchronisieren zu setzen
              setState(
                () {
                  galleryImages.addAll(images);
                  calculatedOutcome.material = 0.0;
                },
              );
              // speichert die neuen Fotos in der Datenbank
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
              setUpAssets();
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
          /// die folgende If condition ist frei nach https://flutterigniter.com/dismiss-keyboard-form-lose-focus/ und verhindert,
          /// dass die Tastatur rumbuggt, wenn man die Kamera öffnet
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          addPhoto();
        },
      ),
    );
  }

  /// Dialog bei "Projekt löschen"
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

  /// gibt den Kunden für die App-Bar zurück
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

  /// gibt die Adresse, aber nur wenn vollständig für die App-Bar zurück
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                  onClick: () {
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
                        setUpAssets();
                      }),
                    ),
                  ),
                ),
                Visibility(
                  visible: !editorVisablity,
                  child: Column(
                    children: [
                      Dashboard(
                        walls: walls,
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
                            }, () {
                              _ServerMessage();
                            });
                            setState(() {
                              recalculate = false;
                            });
                          }
                          setUpAssets();
                        },
                      ),
                      Webshop(
                        outcome: calculatedOutcome,
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
                        color: GeneralStyle.getLightGray(),
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
                      AllData(content: content),
                      Walls(
                        content: content,
                        walls: walls,
                        updateWalls: (newWalls) {
                          setState(() {
                            walls = newWalls;
                          });
                          setUpAssets();
                        },
                      ),
                    ],
                  ),
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
      ),
    );
  }
}
