import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/button_multiple_icons.dart';
import 'package:prototype/components/custom_container_white.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';
import 'package:prototype/screens/create_new_project/input_field_address.dart';
import 'package:prototype/screens/load_project/editor.dart';
import 'package:prototype/components/gallery.dart';
import 'package:prototype/components/navBar.dart';
import 'package:prototype/screens/load_project/projectMap.dart';
import 'package:prototype/screens/load_project/webshop_api.dart';
import 'package:camera/camera.dart';
import 'package:prototype/styles/container.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../backend/server_ai.dart';
import '../../components/screen_camera.dart';
import '../../backend/value_calculator.dart';
import 'package:prototype/backend/data_base_functions.dart';

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

  /// eine Liste aller Bilder die der Nutzer nachträglich hinzugefügt hat und die noch
  /// nicht abgespeichert wurden
  List<CustomCameraImage> addedImages = [];

  /// eine Liste aller Bilder zu denen noch kein KI Ergebnis vorliegt
  List<CustomCameraImage> galleryImagesNotYetCalculated = [];
  bool safeNewPicturesButton = false;
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

  Future<void> _launchUrl() async {
    String urlString =
        "https://www.google.com/maps/place/${content.street}+${content.houseNumber},+${content.zip}+${content.city}";
    Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
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
          Text(
              "KI-Ergebnis: ${calculatedOutcome.aiOutcome.toStringAsFixed(2)} kg"),
          Text(
              "KI-Preis: ${calculatedOutcome.totalAiPrice.toStringAsFixed(2)} €"),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "KI-Ergebnis: ${calculatedOutcome.aiOutcome.toStringAsFixed(2)}"),
          Text(
              "KI-Preis: ${calculatedOutcome.totalAiPrice.toStringAsFixed(2)} €"),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>last value: $originalLastValue");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          content.projectName,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Center(
            child: ProjectMap(
              adress: Adress(
                  street: content.street,
                  houseNumber: content.houseNumber,
                  city: content.city,
                  zip: content.zip),
            ),
          ),
          CustomContainerWhite(
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
                    }),
                  ),
                ),
              ],
            ),
          ),
          // test to check if Project view is able to load data, which had been entered before

          CustomContainerWhite(
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
          CustomContainerWhite(
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Gallery(
                    pictures: galleryImages,
                    deleteFunction: (id) async {
                      galleryImages.removeWhere((element) => element.id == id);
                      var sh = await DataBase.deleteSingleImageFromTable(
                          content.id, id);
                      var sh2 = await DataBase.deleteSingleImageFromDirectory(
                          content.id, id);
                      loadGalleryPictures();
                      print(
                          ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${galleryImages.length.toString()}");
                    },
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: CustomButton(
                    children: const [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.image,
                        color: Colors.white,
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
                              updateGallery: (images) {
                                setState(
                                  () {
                                    galleryImages.addAll(images);
                                    addedImages.addAll(images);
                                    safeNewPicturesButton = true;
                                  },
                                );
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
            visible: safeNewPicturesButton,
            child: CustomButton(
              children: const [
                Icon(
                  Icons.image,
                  color: Colors.white,
                ),
                Icon(
                  Icons.save,
                  color: Colors.white,
                ),
              ],
              onPressed: () async {
                bool sth = await DataBase.saveImages(
                  pictures: addedImages,
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
                setState(() {
                  safeNewPicturesButton = false;
                  addedImages = [];
                });
              },
            ),
          ),
          Visibility(
            visible: safingImages,
            child: Text("Speichere Bilder $state %"),
          ),

          Webshop(
            aiValue: calculatedOutcome.aiOutcome,
          )
        ]),
      ),
      bottomNavigationBar: NavBar(4),
    );
  }
}
