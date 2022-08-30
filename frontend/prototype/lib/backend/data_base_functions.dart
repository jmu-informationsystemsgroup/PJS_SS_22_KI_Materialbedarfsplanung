import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:camera/camera.dart';

import 'package:prototype/backend/helper_objects.dart';
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

  /// ####################################################################################################################################
  /// ############## Datenbank und Datenbanktabellen
  /// ####################################################################################################################################

  /// erstellt die Projekttabelle für die Datenbank
  static Future<void> createProjectTable(sql.Database database) async {
    await database.execute("""CREATE TABLE projects(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        projectName TEXT,
        client TEXT,
        material TEXT,
        statusActive INTEGER,
        date TEXT
      )
      """);
  }

// ToDo: Primary Key (zusammengesetzter Primärschlüssel aus WallID und projectID)
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

  /// erstellt die Tabelle mit Verweisen auf die Fotos für die Datenbank
  /// die Fotos slebst werden nicht in der Datenbank abgelegt, stattdessen werden hier Verweise auf die Lokation
  /// der Fotoas abgelegt
  static Future<void> createImageTable(sql.Database database) async {
    await database.execute("""CREATE TABLE images(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        projectId INTEGER,
        aiValue REAL
      )
      """);
  }

  static Future<void> createUserTable(sql.Database database) async {
    await database.execute("""CREATE TABLE user_data(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        firstName TEXT,
        lastName TEXT,
        customerId INTEGER,
        address TEXT
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
        await createImageTable(database);
        await createUserTable(database);
      },
    );
  }

  /// ####################################################################################################################################
  /// ############## Daten laden
  /// ####################################################################################################################################

  /// gibt eine Liste aller aktiven Projekte zurück
  /// @Params: term = Suchfilter, orderParameter = Begriff nach welchem geordnet wird
  static Future<List<Content>> getAllActiveProjects(
      [String term = "", String orderByParamter = "id"]) async {
    final db = await DataBase.getDataBase();

    List listOfMaps = await db.query('projects',
        orderBy: "$orderByParamter COLLATE NOCASE",
        where:
            "(statusActive = 1) AND (projectName LIKE '%$term%' OR client LIKE '%$term%')");

    List allImages = await getAllImages();

    List<Content> contentList = [];
    Content contentElement;
    listOfMaps.forEach(
      (element) => {
        contentElement = Content.mapToContent(element),
        allImages.forEach(
          (pictureObject) {
            if (pictureObject["projectId"] == contentElement.id) {
              contentElement.pictures.add(pictureObject["image"]);
            }
          },
        ),
        contentList.add(contentElement),
      },
    );
    return contentList;
  }

  /// gibt eine Liste der archivierten Projekte zurück
  static Future<List<Content>> getAllArchivedProjects() async {
    final db = await DataBase.getDataBase();
    List listOfMaps =
        await db.query('projects', orderBy: "id", where: "statusActive = 0");

    List allImages = await getAllImages();

    List<Content> contentList = [];
    Content contentElement;
    listOfMaps.forEach(
      (element) => {
        contentElement = Content.mapToContent(element),
        allImages.forEach(
          (pictureObject) {
            if (pictureObject["projectId"] == contentElement.id) {
              contentElement.pictures.add(pictureObject["image"]);
            }
          },
        ),
        contentList.add(contentElement),
      },
    );
    return contentList;
  }

  static Future<List<dynamic>> getUserData() async {
    final db = await DataBase.getDataBase();
    return db.query('user_data', orderBy: "id");
  }

  /// gibt alle Wände eines bestimmten Projekts anhand der Projekt Id zurück
  static getWalls(int id) async {
    final db = await DataBase.getDataBase();

    return db
        .query('walls', orderBy: "id", where: "projectId = ?", whereArgs: [id]);
  }

  static Future<Content> getSpecificProject(int id) async {
    final db = await DataBase.getDataBase();

    List listOfMaps = await db
        .query('projects', orderBy: "id", where: "id = ?", whereArgs: [id]);

    List allImages = await getImages(id);

    List<Content> contentList = [];
    Content contentElement;

    contentElement = Content.mapToContent(listOfMaps[0]);
    allImages.forEach(
      (pictureObject) {
        contentElement.pictures.add(pictureObject["image"]);
      },
    );

    return contentElement;
  }

  static Future<List> getAllImages() async {
    final db = await DataBase.getDataBase();

    var path = await getFilePath;

    var list = [];

    var images = await db.query('images', orderBy: "id");

    for (var element in images) {
      var imageId = element["id"];

      var imageObject = {
        "image": XFile('$path/material_images/$imageId.jpg'),
        "projectId": element["projectId"]
      };

      list.add(imageObject);
    }

    return list;
  }

  static Future<List> getImages(int projectId) async {
    final db = await DataBase.getDataBase();

    var path = await getFilePath;

    var list = [];

    var images = await db.query('images',
        orderBy: "id", where: "projectId = ?", whereArgs: [projectId]);

    for (var element in images) {
      var imageId = element["id"];

      var imageObject = {
        "image": XFile('$path/material_images/$imageId.jpg'),
        "aiValue": element["aiValue"]
      };

      list.add(imageObject);
    }

    return list;
  }

  /// ####################################################################################################################################
  /// ############## Daten löschen
  /// ####################################################################################################################################

  /// löscht das Projekt aus der Datenbank
  static deleteProject(int id) async {
    final db = await DataBase.getDataBase();
    try {
      await db.delete("projects", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }

    deleteImages(id);
    deleteWalls(id);
  }

  static deleteImages(int projectId) async {
    final db = await DataBase.getDataBase();

    var images = await db.query('images',
        orderBy: "id", where: "projectId = ?", whereArgs: [projectId]);

    final path = await getFilePath;

    for (var element in images) {
      var imageId = element["id"];
      var file = File('$path/material_images/$imageId.jpg');
      file.delete();
    }
    try {
      await db.delete("images", where: "projectId = ?", whereArgs: [projectId]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static deleteWalls(int projectId) async {
    final db = await DataBase.getDataBase();
    try {
      await db.delete("walls", where: "projectId = ?", whereArgs: [projectId]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  /// ####################################################################################################################################
  /// ############## Daten bearbeiten
  /// ####################################################################################################################################

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

  static updateContent(int id, Content content) async {
    final db = await DataBase.getDataBase();
    final data = {
      'projectName': content.projectName,
      'client': content.client,
      'date': content.date,
    };

    final result =
        await db.update('projects', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static updateUser(User data) async {
    final db = await DataBase.getDataBase();
    int id = 1;

    final dbData = {
      'firstName': data.firstName,
      'lastName': data.lastName,
      'customerId': data.customerId,
      'address': data.address
    };
    final result =
        await db.update('user_data', dbData, where: "id = ?", whereArgs: [id]);
    return result;
  }

  /// ####################################################################################################################################
  /// ############## Daten anlegen
  /// ####################################################################################################################################

  /// fügt das erzeugte Datenobjekt in die Datenbank ein
  static Future<int> createNewProject(Content data) async {
    final dbData = {
      'projectName': data.projectName,
      'client': data.client,
      'material': data.material,
      'statusActive': data.statusActive,
      'date': data.date
    };

    final db = await DataBase.getDataBase();

    final id = await db.insert('projects', dbData,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    createWallsForProject(data, id);
    saveImages(data, id);
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

  static createUserData(User data) async {
    final db = await DataBase.getDataBase();

    final dbData = {
      'firstName': data.firstName,
      'lastName': data.lastName,
      'customerId': data.customerId,
      'address': data.address
    };
    final id = await db.insert('user_data', dbData,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  /// die Fotos werden in einem Ordner hinterlegt, der nach der id des Projekts benannt wird
  /// Bild id = Dateiname
  static void saveImages(Content data, int projectId) async {
    List<XFile?> pictures = data.pictures;

    final db = await DataBase.getDataBase();

    final path = await getFilePath;
    // neuen ordner erstellen, falls noch nicht vorhanden
    var dir = await Directory('$path/material_images').create(recursive: true);

    var fileloc = dir.path;

    for (var picture in pictures) {
      final dbData = {'projectId': projectId, 'aiValue': data.aiValue};

      final id = await db.insert('images', dbData,
          conflictAlgorithm: sql.ConflictAlgorithm.replace);

      await picture?.saveTo('$fileloc/$id.jpg');
    }
  }
}
