import 'dart:typed_data';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image/image.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:camera/camera.dart';

import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/backend/server_ai.dart';
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
        date TEXT,
        comment TEXT,
        street TEXT,
        houseNumber TEXT,
        zip TEXT,
        city TEXT
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
        projectId INTEGER,
        id INTEGER NOT NULL,
        aiValue REAL,
        PRIMARY KEY (id, projectId),
        FOREIGN KEY (projectId) REFERENCES projects (id)
      )
      """);
  }

  static Future<void> createUserTable(sql.Database database) async {
    await database.execute("""CREATE TABLE user_data(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        firstName TEXT,
        lastName TEXT,
        customerId INTEGER,
        street TEXT,
        houseNumber TEXT,
        zip TEXT,
        city TEXT
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
  static Future<List<Content>> getProjects(
      {String searchTerm = "",
      String orderByParamter = "id",
      int statusActive = 1}) async {
    final db = await DataBase.getDataBase();

    List listOfMaps = await db.query('projects',
        orderBy: "$orderByParamter COLLATE NOCASE",
        where:
            "(statusActive = $statusActive) AND (projectName LIKE '%$searchTerm%' OR client LIKE '%$searchTerm%' OR street LIKE '%$searchTerm%' OR city LIKE '%$searchTerm%' OR zip LIKE '%$searchTerm%' OR comment LIKE '%$searchTerm%')");

    // List allImages = await getAllImages();

    List<Content> contentList = [];
    Content contentElement;
    listOfMaps.forEach(
      (element) => {
        contentElement = Content.mapToContent(element),
        /*
        allImages.forEach(
          (pictureObject) {
            if (pictureObject["projectId"] == contentElement.id) {
              contentElement.pictures.add(pictureObject["image"]);
            }
          },
        ),
        */
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

    //  List allImages = await getAllImages();

    List<Content> contentList = [];
    Content contentElement;
    listOfMaps.forEach(
      (element) => {
        contentElement = Content.mapToContent(element),
        /*
        allImages.forEach(
          (pictureObject) {
            if (pictureObject["projectId"] == contentElement.id) {
              contentElement.pictures.add(pictureObject["image"]);
            }
          },
        ),
        */
        contentList.add(contentElement),
      },
    );
    return contentList;
  }

  static Future<User?> getUserData() async {
    final db = await DataBase.getDataBase();

    List userData = await db.query('user_data', orderBy: "id");
    User user = User();
    if (userData.isNotEmpty) {
      user = User.mapToUser(userData[0]);
      return user;
    } else {
      return null;
    }
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

    List<CustomCameraImage> allImages = await getImages(projectId: id);

    List<Content> contentList = [];
    Content contentElement;

    contentElement = Content.mapToContent(listOfMaps[0]);
    contentElement.pictures = allImages;

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
        "image":
            XFile('$path/material_images/${element["projectId"]}_$imageId.jpg'),
        "projectId": element["projectId"]
      };

      list.add(imageObject);
    }

    return list;
  }

  /// gibt alle Bilder zu einer projectId als CustomCameraImage Liste zurück, onlyNewImages wird für
  /// die aufwändige KI Berechnung benutzt, indem hier nur Bilder nachgeladen werden, zu denen noch
  /// kein KI Wert bestimmt wurde
  static Future<List<CustomCameraImage>> getImages(
      {required int projectId,
      bool onlyNewImages = false,
      bool deletetableImages = false}) async {
    final db = await DataBase.getDataBase();

    String additionalCommand = "";

    if (onlyNewImages) {
      additionalCommand = "AND aiValue <= 0";
    } else if (deletetableImages) {
      additionalCommand = "AND aiValue < 0";
    }

    var path = await getFilePath;

    List<CustomCameraImage> list = [];

    var images = await db.query('images',
        orderBy: "id", where: "projectId = $projectId $additionalCommand");

    for (var element in images) {
      String imageId = element["id"].toString();
      String aiValue = element["aiValue"].toString();
      String projectId = element["projectId"].toString();

      CustomCameraImage imageObject = CustomCameraImage(
        id: int.parse(imageId),
        image: XFile('$path/material_images/${projectId}_$imageId.jpg'),
        aiValue: double.parse(aiValue),
        projectId: int.parse(projectId),
      );

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
      var file = File('$path/material_images/${projectId}_$imageId.jpg');
      file.delete();
    }
    try {
      await db.delete("images", where: "projectId = ?", whereArgs: [projectId]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static deleteSingleImageFromTable(int projectId, int id) async {
    final db = await DataBase.getDataBase();
    try {
      await db.delete("images", where: "projectId = $projectId AND id = $id");
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static deleteSingleImageFromDirectory(int projectId, int imageId) async {
    final path = await getFilePath;

    var file = File('$path/material_images/${projectId}_$imageId.jpg');
    file.delete();
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
      'comment': content.comment,
      'street': content.street,
      'houseNumber': content.houseNumber,
      'zip': content.zip,
      'city': content.city,
      'material': content.material
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
      'street': data.street,
      'houseNumber': data.houseNumber,
      'zip': data.zip,
      'city': data.city,
    };
    final result =
        await db.update('user_data', dbData, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static updateImagesAiValue(double aiValue, int id, int projectId) async {
    final db = await DataBase.getDataBase();

    final dbData = {
      'aiValue': aiValue,
    };
    final result = await db.update('images', dbData,
        where: "id = ${id} AND projectId = ${projectId}");
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
      'date': data.date,
      'comment': data.comment,
      'street': data.street,
      'houseNumber': data.houseNumber,
      'zip': data.zip,
      'city': data.city
    };

    final db = await DataBase.getDataBase();

    final id = await db.insert('projects', dbData,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    createWallsForProject(data, id);

    if (data.projectName == "") {
      data.projectName = "Projekt Nr. $id";
    }

    DataBase.updateContent(id, data);

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
      'street': data.street,
      'houseNumber': data.houseNumber,
      'zip': data.zip,
      'city': data.city,
    };
    final id = await db.insert('user_data', dbData,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  /// die Fotos werden im Ordner "material images hinterlegt"
  static Future<bool> saveImages(
      {required List<CustomCameraImage> pictures,
      required int projectId,
      required Function(int) updateState,
      int startId = 1}) async {
    final db = await DataBase.getDataBase();

    final path = await getFilePath;
    // neuen ordner erstellen, falls noch nicht vorhanden
    var dir = await Directory('$path/material_images').create(recursive: true);

    var fileloc = dir.path;

    int id = startId;
    List<CustomCameraImage> uploadList = [];

    double currentState = 0.0;
    double finishedState = pictures.length.toDouble();
    double step = 100.0 / finishedState;

    for (var picture in pictures) {
      final dbData = {'projectId': projectId, 'id': id, 'aiValue': 0.0};

      final id2 = await db.insert('images', dbData,
          conflictAlgorithm: sql.ConflictAlgorithm.replace);

      try {
        // var waitForMe = await picture?.saveTo('$fileloc/${projectId}_$id.jpg');

        /*
      try {
        uploadList.add(
          CustomCameraImage(
              id: id, projectId: projectId, image: picture!, aiValue: 0.0),
        );
      } catch (e) {
        print(
            ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Bild erstellen war zu langsam");
      }
      */
        Uint8List prefine = await picture.image.readAsBytes();
        List<int> byteList = [];
        for (var element in prefine) {
          byteList.add(element);
        }

        img.Image? image = decodeImage(byteList);

        img.Image imageCropped = copyCrop(
            image!, 0, 0, (image.height * 4 / 3).toInt(), image.height);

        img.Image resizedImage =
            copyResize(imageCropped, width: 400, height: 300);

        //   resizedImage = copyCrop(resizedImage, int x, int y, int w, int h);

        File file = await File('$fileloc/${projectId}_$id.jpg').create();

        file.writeAsBytesSync(encodeJpg(resizedImage, quality: 100));
      } catch (e) {
        deleteSingleImageFromTable(projectId, id);
        print("Bild $id wurde nicht gespeichert");
      }

      id = id + 1;
      currentState = currentState + step;
      updateState(currentState.toInt());
    }
/*
    ServerAI.sendImages(uploadList);
*/
    return true;
  }

  static Future<FileSystemEntity> loadImageFromHardcodedPath() async {
    var path = await getFilePath;
    // var file = File('$path/material_images/1/IMG_2098.JPG');
    var file = File('$path/material_images/1/ai_training_image.JPG');

    return file;
  }
}
