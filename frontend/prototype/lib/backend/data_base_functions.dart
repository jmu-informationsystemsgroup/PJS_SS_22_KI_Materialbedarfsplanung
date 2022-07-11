import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:camera/camera.dart';

import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/screen_create_new_project/_main_view.dart';
import 'package:sqflite/sqflite.dart' as sql;

/// beinhaltet sämtliche Methoden zum Speichern und Laden von Daten
class DataBase {
  /// für allem fürs Debugging: legt Dateien im Downloads Ordner an, sodass diese
  /// ausgelesen und kontrolliert werden können, stellt außerdem eine Berechtigungsfrage
  /// ans das Handy auf Speicherzugriff
  static Future<String?> get getFilePath async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    Directory? tempDir = await DownloadsPathProvider.downloadsDirectory;
    String? tempPath = tempDir?.path;
    return tempPath;
  }

  /// wird aktuell noch für Fotos benötigt, kann entfernt werden, soblald komplett auf
  /// Datenbanken umgezogen wurde
  static Future<File> get getIdFile async {
    final path = await getFilePath;
    return File('$path/idFile.json');
  }

  /// erstellt die Projekttabelle für die Datenbank
  static Future<void> createProjectTable(sql.Database database) async {
    await database.execute("""CREATE TABLE projects(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        projectName TEXT,
        client TEXT,
        material TEXT,
        statusActive INTEGER
      )
      """);
  }

  /// FÜR MVP: erstellt die Wandtabelle für die Datenbank
  static Future<void> createWallTable(sql.Database database) async {
    await database.execute("""CREATE TABLE walls(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        projectId INTEGER,
        width REAL,
        height REAL
      )
      """);
  }

  /// gibt die Datenbank zurück oder erstellt eine neue, falls noch nicht vorhanden
  static Future<sql.Database> getDataBase() async {
    String? tempPath = await getFilePath;

    return sql.openDatabase(
      '$tempPath/spachtlerData.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createProjectTable(database);
        await createWallTable(database);
      },
    );
  }

/*
  /// gibt die Datenbank zurück oder erstellt eine neue, falls noch nicht vorhanden
  static Future<sql.Database> getWallsDataBase() async {
    String? tempPath = await getFilePath;
    return sql.openDatabase(
      '$tempPath/mvp_walls.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {},
    );
  }
  */

  /// gibt eine Liste aller aktiven Projekte zurück
  /// SPÄTER: NACH NÄCHSTEM FÄLLIGKEITSDATUM ORDNEN
  static Future<List<dynamic>> getAllActiveProjects() async {
    final db = await DataBase.getDataBase();

    return db.query('projects', orderBy: "id", where: "statusActive = 1");
  }

  /// gibt eine Liste der archivierten Projekte zurück
  static Future<List<dynamic>> getAllArchivedProjects() async {
    final db = await DataBase.getDataBase();
    return db.query('projects', orderBy: "id", where: "statusActive = 0");
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
      await db.delete("projects", where: "id = ?", whereArgs: [id]);
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
        await db.update('projects', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  /// ändert statusActive = 0 zurück in statusActive = 1, dadurch wird das Projekt
  /// nicht mehr in der Liste der aktiven Projekte angezeigt
  static activateProject(int id) async {
    final db = await DataBase.getDataBase();

    final data = {
      'statusActive': 1,
    };

    final result =
        await db.update('projects', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  /// fügt das erzeugte Datenobjekt in die Datenbank ein
  static Future<int> createNewProject(Content data) async {
    final db = await DataBase.getDataBase();

    final dbData = {
      'projectName': data.projectName,
      'client': data.client,
      'material': data.material,
      'statusActive': data.statusActive
    };

    final id = await db.insert('projects', dbData,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    createWallsForProject(data, id);

    return id;
  }

  /// FÜR MVP: Wenn es eine Wall Liste gibt, werden die Elemente dieser in den MVP Wand Tabelle eingetragen
  static createWallsForProject(Content data, int projectId) async {
    final db = await DataBase.getDataBase();

    Iterable<Wall> squareMeters = data.squareMeters.values;

    squareMeters.forEach((element) async {
      final dbData = {
        'projectId': projectId,
        'width': element.width,
        'height': element.height
      };
      final id = await db.insert('walls', dbData,
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    });
  }

  /// gibt alle Wände eines bestimmten Projekts anhand der Projekt Id zurück
  static getWalls(int id) async {
    final db = await DataBase.getDataBase();

    return db
        .query('walls', orderBy: "id", where: "projectId = ?", whereArgs: [id]);
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
