import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/button_row_multiple_icons.dart';
import 'package:prototype/components/custom_container_white.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';
import 'package:prototype/screens/create_new_project/input_field_address.dart';
import 'package:prototype/screens/home/_main_view.dart';
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
  List<Widget> outcomeWidgetList = [];
  int state = 0;
  bool recalculate = false;
  bool safingImages = false;
  int originalLastValue = 0;

  @override
  void initState() {
    // TODO: implement initState
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
    List<CustomCameraImage> saveState =
        await DataBase.getImages(projectId: content.id);
    CalculatorOutcome val =
        await ValueCalculator.getOutcomeObject(content, saveState);
    originalLastValue = saveState.last.id;

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

  Icon getIcon() {
    if (editorVisablity) {
      return Icon(Icons.close);
    } else
      return Icon(Icons.edit);
  }

  Widget renderArchiveButton(int id) {
    if (content.statusActive == 0) {
      return ElevatedButton(
        onPressed: () {
          DataBase.activateProject(id);
        },
        child: const Icon(Icons.settings_backup_restore),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          DataBase.archieveProject(id);
        },
        child: const Icon(Icons.archive),
      );
    }
  }

  Future<void> _launchUrl() async {
    String urlString =
        "https://www.google.com/maps/place/${content.street}+${content.houseNumber},+${content.zip}+${content.city}";
    Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  Widget outComeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Qualität: ${content.material}"),
        Text(
            "KI-Ergebnis: ${calculatedOutcome.aiOutcome.toStringAsFixed(2)} kg"),
        Text(
            "KI-Preis: ${calculatedOutcome.totalAiPrice.toStringAsFixed(2)} €"),
      ],
    );
  }

  Widget displayData() {
    if (galleryImages.isEmpty) {
      return Text("Mache Bilder um einen KI Wert ermitteln zu können");
    } else if (recalculate) {
      return Text("Status: $state%");
    } else if (calculatedOutcome.aiOutcome == 0.0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Um den Bedarf zu ermitteln synchronisiere deine Bilddaten"),
          ElevatedButton(
            onPressed: () async {
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
            child: Text("Bilder synchronisieren"),
          ),
        ],
      );
    } else if (calculatedOutcome.exception) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(calculatedOutcome.exceptionText),
          Text("Aus den übrigen Bildern ergibt sich folgender Wert:"),
          outComeText(),
        ],
      );
    } else {
      return outComeText();
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
          subTitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconAndText(
                text: "Aufttraggeber: ${content.client}",
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
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: ProjectMap(
                  adress: Adress(
                      street: content.street,
                      houseNumber: content.houseNumber,
                      city: content.city,
                      zip: content.zip),
                ),
              ),
              CustomContainerBorder(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: !editorVisablity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Auftraggeber: " + content.client),
                          Text("Datum: " + content.date),
                          Text(
                              "Adresse: ${content.street} ${content.houseNumber} ${content.zip} ${content.city}"),
                          ElevatedButton(
                            child: Icon(Icons.map),
                            onPressed: () {
                              setState(() {
                                _launchUrl();
                              });
                            },
                          ),
                          Text("Kommentar: " + content.comment),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      child: getIcon(),
                      onPressed: () {
                        setState(() {
                          editorVisablity = changeBool(editorVisablity);
                        });
                      },
                    ),
                    Visibility(
                      visible: editorVisablity,
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
                  ],
                ),
              ),
              // test to check if Project view is able to load data, which had been entered before

              CustomContainerBorder(
                child: displayData(),
              ),

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
                        deleteFunction: (element) async {
                          setState(() {
                            element.display = false;
                          });
                          var sh = await DataBase.deleteSingleImageFromTable(
                              content.id, element.id);
                          var sh2 =
                              await DataBase.deleteSingleImageFromDirectory(
                                  content.id, element.id);
                          loadGalleryPictures();

                          print(
                              ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${galleryImages.length.toString()}");
                        },
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: CustomButtonRow(
                        children: [
                          Icon(
                            Icons.add,
                            color: GeneralStyle.getUglyGreen(),
                          ),
                          Icon(
                            Icons.image,
                            color: GeneralStyle.getUglyGreen(),
                          ),
                        ],
                        onPressed: () async {
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
                        },
                      ),
                    ),
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
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    child: ElevatedButton(
                      onPressed: () {
                        DataBase.deleteProject(content.id);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Icon(Icons.delete),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    child: renderArchiveButton(content.id),
                  ),
                ],
              ),

              Webshop(
                aiValue: calculatedOutcome.aiOutcome,
              )
            ],
          ),
        ),
        navBar: NavBar(99),
      ),
    );
  }
}
