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

  static Future<File> get getFile async {
    final path = await getFilePath;
    return File('$path/myfile.txt');
  }

  /// gibt ein JSON File mit allen aktiven Projekten zurück
  static Future<File> get getActiveProjects async {
    final path = await getFilePath;
    return File('$path/activeProjects.json');
  }

  /// gibt ein JSON File mit allen archivierten Projekten zurück
  static Future<File> get getArchievedProjects async {
    final path = await getFilePath;
    return File('$path/archievedProjects.json');
  }

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

  static Future<Map<String, dynamic>> readJsonFile() async {
    String fileContents = '';
    try {
      final file = await getActiveProjects;
      fileContents = await file.readAsString();
    } catch (e) {
      print("File konnte nicht gefunden werden");
    }
    print(json.decode(fileContents).toString());
    return json.decode(fileContents);
  }

  /// fügt das erzeugte Datenobjekt in ein JSON File ein, dazu müssen die bisherigen Daten herausgelesen werden, mit dem neuen Datenobjekt zu einem
  /// neuen JSON String kombiniert werden. Dieser JSON String überschreibt dann den bisherigen
  static Future<Content> addToJsonFile(data) async {
    final Content content = data;
    String completeContent = "";
    try {
      final file = await getActiveProjects;
      completeContent = await file.readAsString();
      completeContent = completeContent.replaceAll("[[]]", "");
    } catch (e) {
      print("File konnte nicht gefunden werden");
    }
    if (completeContent.isEmpty) {
      completeContent = jsonEncode(content).toString();
    } else {
      completeContent = completeContent + "," + jsonEncode(content).toString();
    }

    File finalFile = await getActiveProjects;
    await finalFile.writeAsString("[$completeContent]");

    return data;
  }

  static void saveImages(List<XFile?> pictures) async {
    final path = await getFilePath;
    String projectName = NewProject.cash.projectName;
    // neuen ordner erstellen
    var dir = await Directory('$path/$projectName').create(recursive: true);
    var fileloc = dir.path;
    int pictureNr = 0;
    for (var picture in pictures) {
      picture?.saveTo('$fileloc/$pictureNr.png');
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
