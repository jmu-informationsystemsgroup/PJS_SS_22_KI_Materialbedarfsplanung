import 'package:flutter/material.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/button_multiple_icons.dart';
import 'package:prototype/components/custom_container_white.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';
import 'package:prototype/screens/load_project/editor.dart';
import 'package:prototype/components/gallery.dart';
import 'package:prototype/components/navBar.dart';
import 'package:prototype/screens/load_project/projectMap.dart';
import 'package:prototype/screens/load_project/webshop_api.dart';
import 'package:camera/camera.dart';
import 'package:prototype/styles/container.dart';
import '../../components/screen_camera.dart';
import '../../backend/value_calculator.dart';
import 'package:prototype/backend/data_base_functions.dart';

class ProjectView extends StatefulWidget {
  Content content;
  ProjectView(this.content);

  static String src = "";
  @override
  _ProjectViewState createState() {
    return _ProjectViewState();
  }
}

class _ProjectViewState extends State<ProjectView> {
  Map<String, dynamic> calculatedOutcome = {};
  bool editorVisablity = false;
  Content content = Content();
  List<XFile?> galleryPictures = [];
  List<XFile?> addedPictures = [];
  bool safeNewPicturesButton = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOutcome();
    content = widget.content;
    galleryPictures = content.pictures;
  }

  getOutcome() {
    ValueCalculator.getOutcomeObject(widget.content).then((value) => {
          setState(() {
            calculatedOutcome = value;
          })
        });
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
          //      Center(child: ProjectMap()),
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
                      Text("Kommentar: " + content.comment)
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("KI-Ergebnis: " +
                    calculatedOutcome["aiOutcome"].toString()),
                Text("KI-Preis: " +
                    calculatedOutcome["totalAiPrice"].toString()),
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

          Gallery(pictures: galleryPictures),
          Container(
            width: 70,
            decoration: ContainerStyles.roundetCorners(),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: GestureDetector(
              onTap: () async {
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
                                  });
                                },
                              )),
                    ));
              },
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.image,
                      color: Colors.white,
                    ),
                  ]),
            ),
          ),
          Visibility(
            visible: safeNewPicturesButton,
            child: CustomButton(
              children: [
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
                DataBase.saveImages(addedPictures, content.id);
              },
            ),
          ),
          Webshop(
            aiValue: calculatedOutcome["aiOutcome"],
          )
        ]),
      ),
      bottomNavigationBar: NavBar(4),
    );
  }
}
