import 'package:camera/camera.dart';

import 'file_utils.dart';

/// erzeugt ein Objekt das als Zwischenspeicher für die zukünftig zu speichernden Informationen
/// dient. Die Content Klasse beinhaltet außerdem Funktionen zum Arbeiten mit JSON-Dateien
class Content {
  int id = 0;
  String projectName = "Default";
  String client = "Default";
  List<List<double>> squareMeters = [[]];
  //Enum marterial
  List<XFile?> pictures = [];

  set fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectName = json['projectName'];
    client = json['client'];
    squareMeters = json['squareMeters'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'projectName': projectName,
        'client': client,
        'squareMeters': squareMeters
      };

/*
  static Map<String, dynamic> createMap() {
    Map<String, dynamic> content = {'id': '', 'projectName': "", 'client': ""};

    return content;
  }
  */
}



// TODO project id: get highest id + 1