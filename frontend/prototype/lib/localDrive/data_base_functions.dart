import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:camera/camera.dart';

import 'package:prototype/localDrive/content.dart';
import 'package:prototype/newProject/mainView.dart';
import 'package:sqflite/sqflite.dart' as sql;

/// beinhaltet sämtliche Methoden zum Speichern und Laden von Daten
class DataBase {
  static Future<String?> get getFilePath async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    Directory? tempDir = await DownloadsPathProvider.downloadsDirectory;
    String? tempPath = tempDir?.path;
    return tempPath;
  }

  static Future<File> get getIdFile async {
    final path = await getFilePath;
    return File('$path/idFile.json');
  }

  /// erstellt die Tabelle für die Datenbank
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        projectName TEXT,
        client TEXT,
        material TEXT,
        statusActive INTEGER
      )
      """);
  }

  /// gibt die Datenbank zurück oder erstellt eine neue, falls noch nicht vorhanden
  static Future<sql.Database> getDataBase() async {
    Directory? tempDir = await DownloadsPathProvider.downloadsDirectory;
    String? tempPath = tempDir?.path;
    return sql.openDatabase(
      '$tempPath/kindacode.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  /// gibt eine Liste aller aktiven Projekte zurück
  static Future<List<dynamic>> getAllActiveProjects() async {
    final db = await DataBase.getDataBase();
    return db.query('items', orderBy: "id", where: "statusActive = 1");
  }

  /// gibt eine Liste der archivierten Projekte zurück
  static Future<List<dynamic>> getAllArchivedProjects() async {
    final db = await DataBase.getDataBase();
    return db.query('items', orderBy: "id", where: "statusActive = 0");
  }

  /// FÄLLT BEI DATENBANK WEG
  /// ruft ein File mit der letzen vergebenen Id auf, Ids werden von 0 nach nahezu undendlich hochgezählt, gibt eine neue id (letzte id + 1)
  /// zurück, überschreibt die im File gespeicherte id
  static Future<int> getId() async {
    int id = 0;
    String jsonId = "";
    Map<String, dynamic> idMap = {"id": 0};

    try {
      File file = await getIdFile;
      jsonId = await file.readAsString();
    } catch (e) {}

    if (jsonId != "") {
      idMap = json.decode(jsonId);
      id = idMap["id"]!;
    }

    return id;
  }

  /// löscht das Projekt aus der Datenbank
  static deleteProject(int id) async {
    final db = await DataBase.getDataBase();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static deleteImageFolder(int id) async {
    final path = await getFilePath;
    var dir = await Directory('$path/material_images/$id');
    dir.delete();
  }

  /// ändert statusActive = 1 in statusActive = 0, dadruch wird das Projekt
  /// nicht mehr in der Liste der aktiven Projekte angezeigt
  static archieveProject(int id) async {
    final db = await DataBase.getDataBase();

    final data = {
      'statusActive': 0,
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  /// ändert statusActive = 0 zurück in statusActive = 1, dadruch wird das Projekt
  /// nicht mehr in der Liste der aktiven Projekte angezeigt
  static activateProject(int id) async {
    final db = await DataBase.getDataBase();

    final data = {
      'statusActive': 1,
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  /// für Datenbank: new Project
  /// fügt das erzeugte Datenobjekt in die Datenbank ein
  static Future<int> createNewProject(Content data) async {
    final db = await DataBase.getDataBase();

    final dbData = {
      'projectName': data.projectName,
      'client': data.client,
      'material': data.material,
      'statusActive': data.statusActive
    };

    final id = await db.insert('items', dbData,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  /// die Fotos werden in einem Ordner hinterlegt, der nach der id des Projekts benannt wird
  static void saveImages(List<XFile?> pictures) async {
    final path = await getFilePath;
    int id = 0;
    try {
      File file = await getIdFile;
      id = await getId() + 1;
    } catch (e) {
      id = 0;
    }

    // neuen ordner erstellen
    var dir =
        await Directory('$path/material_images/$id').create(recursive: true);

    var fileloc = dir.path;
    int pictureNr = 0;
    for (var picture in pictures) {
      await picture?.saveTo('$fileloc/$pictureNr.jpg');
      pictureNr += 1;
    }
  }

  static Future<List<FileSystemEntity>> getImages(String src) async {
    var path = await getFilePath;
    var dir = Directory('$path/material_images/$src');
    var list = dir.list();
    return list.toList();
  }
}
