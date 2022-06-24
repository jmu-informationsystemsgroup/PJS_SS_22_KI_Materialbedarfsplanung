import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:camera/camera.dart';

import 'package:prototype/localDrive/content.dart';
import 'package:prototype/newProject/mainView.dart';

/// beinhaltet sämtliche Methoden zum Speichern und Laden von Daten
class FileUtils {
  static Future<String?> get getFilePath async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    Directory? tempDir = await DownloadsPathProvider.downloadsDirectory;
    String? tempPath = tempDir?.path;
    return tempPath;
  }

/*
  static Future<File> get getFile async {
    final path = await getFilePath;
    return File('$path/myfile.txt');
  }
  */

  static Future<File> get getIdFile async {
    final path = await getFilePath;
    return File('$path/idFile.json');
  }

  /// gibt ein JSON File mit allen aktiven Projekten zurück
  static Future<File> get getActiveProjects async {
    final path = await getFilePath;
    await Permission.manageExternalStorage.request();
    return File('$path/activeProjects.json');
  }

  /// gibt ein JSON File mit allen archivierten Projekten zurück
  static Future<File> get getArchievedProjects async {
    final path = await getFilePath;
    return File('$path/archievedProjects.json');
  }

/*
  static Future<File> saveToFile(String data) async {
    final file = await getFile;
    return file.writeAsString(data);
  }

  static Future<String> readFromFile() async {
    try {
      final file = await getFile;
      String fileContents = await file.readAsString();
      return fileContents;
    } catch (e) {
      return "File konnte nicht gefunden werden";
    }
  }
  */

  /// gibt eine Liste der aktiven Projekte zurück
  static Future<List<dynamic>> readJsonFile() async {
    String fileContents = '';
    try {
      final file = await getActiveProjects;
      fileContents = await file.readAsString();
    } catch (e) {
      print("readJsonFile konnte File nicht finden");
    }
    return json.decode(fileContents);
  }

  /// gibt eine Liste der archivierten Projekte zurück
  static Future<List<dynamic>> readarchievedJsonFile() async {
    String fileContents = '';
    try {
      final file = await getArchievedProjects;
      fileContents = await file.readAsString();
    } catch (e) {
      print("readJsonFile konnte File nicht finden");
    }
    return json.decode(fileContents);
  }

  /// ruft ein File mit der letzen vergebenen Id auf, Ids werden von 0 nach nahezu undendlich hochgezählt, gibt eine neue id (letzte id + 1)
  /// zurück, überschreibt die im File gespeicherte id
  static Future<int> getId() async {
    Map<String, dynamic> idMap = {"id": 0};
    int id = 0;
    String jsonId = "";

    try {
      File file = await getIdFile;
      jsonId = await file.readAsString();
    } catch (e) {}

    if (jsonId != "") {
      idMap = json.decode(jsonId);
      id = idMap["id"]! + 1;
      idMap["id"] = id;
    }
    File file = await getIdFile;
    await file.writeAsString(jsonEncode(idMap).toString());

    return id;
  }

/*
  /// liefert ein angefragtes Projekt zurück.
  /// vergleicht die id's der gelisten aktiven Projekte mit der angeforderten id. Das 'erste' passende Projekt-objekt wird
  /// dann zurück gegeben
  static Future<Map<String, dynamic>> getSpecificProject(int id) async {
    List<dynamic> jsonList = [];
    try {
      jsonList = await readJsonFile();
    } catch (e) {
      jsonList = await readarchievedJsonFile();
    }
    Map<String, dynamic> projectJson = Content.createMap();
    var project = jsonList.where((element) {
      if (element["id"] == id) {
        return true;
      } else {
        return false;
      }
    });

    projectJson = project.first;
    return projectJson;
  }
  */

  /// löscht ein angefragtes Projekt aus dem Json File
  static deleteSpecificProject(int id) async {
    List<dynamic> jsonList = await readJsonFile();

    jsonList.removeWhere((element) {
      if (element["id"] == id) {
        return true;
      } else {
        return false;
      }
    });

    String newContent = jsonEncode(jsonList).toString();

    File finalFile = await getActiveProjects;
    await finalFile.writeAsString(newContent);
  }

  static deleteImageFolder(int id) async {
    final path = await getFilePath;
    var dir = await Directory('$path/$id');
    dir.delete();
  }

  /// löscht ein angefragtes Projekt aus dem activeJson File und fügt es in das archievedJson File ein. Imagefolder bleibt bestehen
  static archieveSpecificProject(int id) async {
    // in die Liste der archivierten Projekte einfügen
    String archievedContent = "";
    List<dynamic> jsonList = await readJsonFile();
    var project = jsonList.where((element) {
      if (element["id"] == id) {
        return true;
      } else {
        return false;
      }
    });
    try {
      final file = await getArchievedProjects;
      archievedContent = await file.readAsString();
      archievedContent = archievedContent.replaceAll(RegExp(r'[[]|]'), "");
    } catch (e) {
      print("addToJsonFile konnte File nicht finden");
    }

    Map<String, dynamic> archievedPorject = project.first;

    if (archievedContent.isEmpty) {
      archievedContent = jsonEncode(archievedPorject).toString();
    } else {
      archievedContent =
          archievedContent + "," + jsonEncode(archievedPorject).toString();
    }

    File archieveFile = await getArchievedProjects;
    await archieveFile.writeAsString("[$archievedContent]");
    // aus den aktiven Projekten rauslöschen
    deleteSpecificProject(id);
  }

  /// fügt das erzeugte Datenobjekt in ein JSON File ein, dazu müssen die bisherigen Daten herausgelesen werden, mit dem neuen Datenobjekt zu einem
  /// neuen JSON String kombiniert werden. Dieser JSON String überschreibt dann den bisherigen
  static Future<Content> addToJsonFile(data) async {
    final Content content = data;
    String completeContent = "";
    try {
      final file = await getActiveProjects;
      completeContent = await file.readAsString();
      completeContent =
          completeContent.substring(1, completeContent.length - 1);
    } catch (e) {
      print("addToJsonFile konnte File nicht finden");
    }

    if (completeContent.isEmpty) {
      completeContent = jsonEncode(content).toString();
    } else {
      content.id = await createId();
      completeContent = completeContent + "," + jsonEncode(content).toString();
    }
    print(completeContent.toString());

    File finalFile = await getActiveProjects;
    await finalFile.writeAsString("[$completeContent]");

    return data;
  }

  /// id muss automatisch erstellt werden, damit Projekte unterscheidbar sind, und um die richtigen Bilder zu verlinken.
  /// Dazu muss auch durch die bisherigen Projekte iteriert werden, um zu überprüfen, dass garantiert kein anderes Projekt
  /// dieselbe Id schon hat.
  /// Die Nutzung vom key in Map<key, value> ist unzerverlässig, da dieser sich ja für alle nachfolgenden Projekte ändert
  /// wenn z.B. eins aus der Mitte gelöscht wird.
  static Future<int> createId() async {
    return await getId();
    /*
    try {
      List<dynamic> jsonList = await readJsonFile();
      var element = jsonList.last;
      return element["id"] + 1;
    } catch (e) {
      return 0;
    }
    */
  }

  /// die Fotos werden in einem Ordner hinterlegt, der nach der id des Projekts benannt wird
  static void saveImages(List<XFile?> pictures) async {
    final path = await getFilePath;
    int id = await createId();

    // neuen ordner erstellen
    var dir = await Directory('$path/$id').create(recursive: true);

    var fileloc = dir.path;
    int pictureNr = 0;
    for (var picture in pictures) {
      await picture?.saveTo('$fileloc/$pictureNr.jpg');
      pictureNr += 1;
    }
  }

  static Future<List<FileSystemEntity>> getImages(String src) async {
    var path = await getFilePath;
    var dir = Directory('$path/$src');
    var list = dir.list();
    return list.toList();
  }
}
