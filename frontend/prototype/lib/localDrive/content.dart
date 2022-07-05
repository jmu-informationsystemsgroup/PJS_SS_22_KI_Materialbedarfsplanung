import 'package:camera/camera.dart';

import 'file_utils.dart';

/// erzeugt ein Objekt das als Zwischenspeicher für die zukünftig zu speichernden Informationen
/// dient. Die Content Klasse beinhaltet außerdem Funktionen zum Arbeiten mit JSON-Dateien
/// TODO: singleton class? https://www.youtube.com/watch?v=noi6aYsP7Go
class Content {
  int id = 0;
  String projectName = "Default";
  String client = "Default";
  List<Map<String, double>> squareMeters = [];
  List<XFile?> pictures = [];
  String material = "Q2";
  // status: active / inactive

  /// übersetzt Objekt aus Json Format
  set fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectName = json['projectName'];
    client = json['client'];
    squareMeters = json['squareMeters'];
    material = json['material'];
  }

  /// übersetzt Objekt in Json Format
  Map<String, dynamic> toJson() => {
        'id': id,
        'projectName': projectName,
        'client': client,
        'squareMeters': squareMeters,
        'material': material
      };

  /// erzeugt ein leeres Porjekt, in welches später geladen JSON Daten eingesetzt werden können
  static Map<String, dynamic> createMap() {
    Map<String, dynamic> content = {
      'id': '',
      'projectName': "",
      'client': "",
      'squaremeters': [],
      'material': ""
    };

    return content;
  }
}



// TODO project id: get highest id + 1