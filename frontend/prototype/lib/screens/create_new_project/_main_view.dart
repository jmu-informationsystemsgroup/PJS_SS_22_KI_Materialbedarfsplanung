import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:prototype/components/gallery.dart';
import 'package:prototype/components/navBar.dart';
import 'package:prototype/components/input_field_date.dart';
import 'package:prototype/screens/home/_main_view.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/screen_camera.dart';

import '../../backend/helper_objects.dart';
import '../load_project/_main_view.dart';
import '../../components/input_field.dart';
import 'mvp_checklist.dart';
import 'mvp_walls.dart';

class NewProject extends StatefulWidget {
  String title = "Neues Projekt";
  // instanzieeren eines Contentobjekts, in dem sämtliche EIngabeinformationen zwischengespeichert werden
  static var cash = Content();
  static List<XFile?> images = [];

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
  var visability = false;
  int projectId = 0;
  List<XFile?> galleryPictures = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    galleryPictures = NewProject.cash.pictures;
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
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Neues Projekt",
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Column(
              children: <Widget>[
                InputField(
                  saveTo: (text) => {NewProject.cash.projectName = text},
                  labelText: "Name",
                ),
                //  NewAddress(),
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
                                          NewProject.cash.pictures
                                              .addAll(images);
                                          galleryPictures =
                                              NewProject.cash.pictures;
                                        });
                                      },
                                    )),
                          ));
                    },
                    child: const Text('Photo hinzufügen'),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      // Pick an image
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        setState(
                          () {
                            NewProject.cash.pictures.add(image);
                            galleryPictures = NewProject.cash.pictures;
                          },
                        );
                      }
                    },
                    child: const Text('Photo hinzufügen - Imagepicker'),
                  ),
                ),
                Gallery(pictures: galleryPictures),
                InputField(
                  saveTo: (text) => {NewProject.cash.client = text},
                  labelText: "Auftraggeber",
                ),
                InputDate(
                  saveTo: (text) => {NewProject.cash.date = text},
                ),
                InputField(
                  saveTo: (text) => {NewProject.cash.comment = text},
                  labelText: "Kommentar",
                  maxLines: 6,
                ),
                // MVPWalls(),
                MVPChecklist(),
                //    preview(),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    child: const Text('Projekt speichern und berechnen'),
                    onPressed: () {
                      //    Content.reset(NewProject.cash);
                      setState(() async {
                        visability = true;
                        projectId =
                            await DataBase.createNewProject(NewProject.cash);

                        bool imagesComplete = await DataBase.saveImages(
                            NewProject.cash.pictures, projectId);
                        NewProject.cash = Content(); //reset
                        NewProject.goToProjectView(projectId, context);
                      });

                      // goBack();
                    },
                  ),
                ),
                Visibility(
                  child: Text("Projekt erfolgreich gespeichert!"),
                  visible: visability,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: NavBar(1),
      ),
    );
  }
}
