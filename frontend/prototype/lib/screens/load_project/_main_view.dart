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
  ValueCalculator calculatedOutcome = ValueCalculator();
  bool editorVisablity = false;
  Content content = Content();
  List<CustomCameraImage> projectImages = [];
  List<XFile?> galleryPictures = [];
  List<XFile?> addedPictures = [];
  bool safeNewPicturesButton = false;
  bool imagesSaved = false;
  List<Widget> outcomeWidgetList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    getOutcome();
    content = widget.content;
    loadGalleryPictures();
    // displayOutcome();
  }

  loadGalleryPictures() async {
    projectImages = await DataBase.getImages(content.id);
    for (var element in projectImages) {
      galleryPictures.add(element.image);
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${element.image.path}");
    }
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

  getOutcome() async {
    calculatedOutcome = await ValueCalculator.getOutcomeObject(widget.content);
  }

  successMessage() async {
    imagesSaved = await DataBase.saveImages(
        addedPictures, content.id, projectImages.last.id + 1);
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

  @override
  Widget build(BuildContext context) {
    // getJsonValues();
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
          ElevatedButton(
            onPressed: () {
              if (galleryPictures.isNotEmpty) {
                ServerAI.sendImages(projectImages);
              }
            },
            child: Text("Bilder synchronisieren"),
          ),
          CustomContainerWhite(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("KI-Ergebnis: " + calculatedOutcome.aiOutcome.toString()),
                Text("KI-Preis: " + calculatedOutcome.totalAiPrice.toString()),
              ],
            ),
          ),
          /*
            Text("Quadratmeter: " +
                    calculatedOutcome["totalSquareMeters"].toString()),
           Text("Preis: " + calculatedOutcome["totalPrice"].toString()),
*/
          Container(
            margin: const EdgeInsets.all(10.0),
            //    child: Text("Adresse: " + element + "straße"),
          ),
          CustomContainerWhite(
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Gallery(pictures: galleryPictures),
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
                      await availableCameras().then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CameraPage(
                                      cameras: value,
                                      originalGallery: galleryPictures,
                                      updateGallery: (images) {
                                        setState(() {
                                          galleryPictures.addAll(images);
                                          addedPictures.addAll(images);
                                          safeNewPicturesButton = true;
                                          imagesSaved = false;
                                        });
                                      },
                                    )),
                          ));
                    },
                  ),
                ),
              ],
            ),
          ),

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
                bool sth = await DataBase.saveImages(addedPictures, content.id);
                var newOutcome =
                    await ValueCalculator.getOutcomeObject(widget.content);
                setState(() {
                  safeNewPicturesButton = false;
                  calculatedOutcome = newOutcome;
                  imagesSaved = sth;
                  addedPictures = [];
                });
              },
            ),
          ),
          Visibility(
            visible: imagesSaved,
            child: Text("Speichern erfolgreich"),
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
