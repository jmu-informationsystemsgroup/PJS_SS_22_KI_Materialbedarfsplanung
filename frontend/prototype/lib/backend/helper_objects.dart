import 'package:camera/camera.dart';

import 'data_base_functions.dart';

/// erzeugt ein Objekt das als Zwischenspeicher für die zukünftig zu speichernden Informationen
/// dient. Die Content Klasse beinhaltet außerdem Funktionen zum Arbeiten mit JSON-Dateien
/// TODO: singleton class? https://www.youtube.com/watch?v=noi6aYsP7Go
class Content {
  int id = 0;
  String projectName = "Default";
  String client = "Default";
  String date = "Default";
  Map<int, Wall> squareMeters = {};
  List<XFile?> pictures = [];
  String material = "Q2";
  int statusActive = 1;
  double aiValue = 41.0;

  /// übersetzt Objekt aus Json Format
  set fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectName = json['projectName'];
    client = json['client'];
    squareMeters = json['squareMeters'];
    material = json['material'];
    statusActive = json['statusActive'];
  }

  /// übersetzt Objekt in Json Format
  Map<String, dynamic> toJson() => {
        'id': id,
        'projectName': projectName,
        'client': client,
        'squareMeters': squareMeters,
        'material': material,
        'statusActive': statusActive
      };

  static Map<String, dynamic> contentToMap(Content content) {
    Map<String, dynamic> map = {
      'projectName': content.projectName,
      'client': content.client,
      'squareMeters': content.squareMeters,
      'material': content.material,
      'statusActive': content.statusActive
    };

    return map;
  }

  static Content mapToContent(Map<String, dynamic> map) {
    Content content = Content();
    content.id = map["id"];
    content.projectName = map["projectName"];
    content.client = map["client"];
    content.date = map["date"];
    content.material = map["material"];
    return content;
  }

  /// erzeugt ein leeres Porjekt, in welches später geladen JSON Daten eingesetzt werden können
  static Map<String, dynamic> emptyMap() {
    Map<String, dynamic> content = {
      'id': '',
      'projectName': "",
      'client': "",
      'squaremeters': [],
      'material': "",
      'statusActive': ""
    };

    return content;
  }
}

class User {
  late String firstName;
  late String lastName;
  late int customerId;
  late String address;

  static Map<String, dynamic> createMap(User user) {
    Map<String, dynamic> content = {
      'firstName': user.firstName,
      'lastName': user.lastName,
      'customerId': user.customerId,
      'address': user.address
    };

    return content;
  }
}

/// erzeugt eine MVP Wand, standardmäßig mit den Werten 0.0 * 0.0
class Wall {
  double width = 0.0;
  double height = 0.0;
}
