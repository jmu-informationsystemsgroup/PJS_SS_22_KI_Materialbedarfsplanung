import 'package:camera/camera.dart';

import 'data_base_functions.dart';

/// erzeugt ein Objekt das als Zwischenspeicher für die zukünftig zu speichernden Informationen
/// dient. Die Content Klasse beinhaltet außerdem Funktionen zum Arbeiten mit JSON-Dateien
/// TODO: singleton class? https://www.youtube.com/watch?v=noi6aYsP7Go
class Content {
  int id = 0;
  String projectName = "Default";
  String client = "Default";
  List<Wall> squareMeters = [];
  List<XFile?> pictures = [];
  String material = "Q2";
  int statusActive = 1;

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

  /// erzeugt ein leeres Porjekt, in welches später geladen JSON Daten eingesetzt werden können
  static Map<String, dynamic> createMap() {
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

/// erzeugt eine MVP Wand, standardmäßig mit den Werten 0.0 * 0.0
class Wall {
  late int key;
  double width = 0.0;
  double height = 0.0;
}
