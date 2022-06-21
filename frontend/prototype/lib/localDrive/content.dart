import 'package:prototype/localDrive/status.dart';
import 'package:camera/camera.dart';

/// erzeugt ein Objekt das als Zwischenspeicher für die zukünftig zu speichernden Informationen
/// dient. Die Content Klasse beinhaltet außerdem Funktionen zum Arbeiten mit JSON-Dateien
class Content {
  late int id;
  String projectName = "Default";
  Enum status = Status.active;
  String client = "Default";
  List<XFile?> pictures = [];

  set fromJson(Map<String, dynamic> json) {
    projectName = json['projectName'];
    status = json['status'];
    client = json['client'];
  }

  Map<String, dynamic> toJson() => {
        'projectName': projectName,
        'status': status.toString(),
        'client': client
      };

  static Map<String, dynamic> createMap() {
    Map<String, dynamic> content = {
      'projectName': "",
      'status': "",
      'client': ""
    };

    return content;
  }
}



// TODO project id: get highest id + 1