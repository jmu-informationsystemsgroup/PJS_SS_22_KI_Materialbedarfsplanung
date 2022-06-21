import 'package:prototype/localDrive/status.dart';
import 'package:camera/camera.dart';

/// erzeugt ein Objekt das als Zwischenspeicher für die zukünftig zu speichernden Informationen
/// dient. Die Content Klasse beinhaltet außerdem Funktionen zum Arbeiten mit JSON-Dateien
class Content {
  late int id;
  String projectName = "Default";
  String client = "Default";
  List<XFile?> pictures = [];

  set fromJson(Map<String, dynamic> json) {
    projectName = json['projectName'];
    client = json['client'];
  }

  Map<String, dynamic> toJson() =>
      {'projectName': projectName, 'client': client};

  static Map<String, dynamic> createMap() {
    Map<String, dynamic> content = {'projectName': "", 'client': ""};

    return content;
  }
}



// TODO project id: get highest id + 1