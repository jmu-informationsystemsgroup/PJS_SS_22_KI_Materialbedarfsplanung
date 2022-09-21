import 'package:camera/camera.dart';

import 'data_base_functions.dart';

/// erzeugt ein Objekt das als Zwischenspeicher für die zukünftig zu speichernden Informationen
/// dient. Die Content Klasse beinhaltet außerdem Funktionen zum Arbeiten mit JSON-Dateien
/// TODO: singleton class? https://www.youtube.com/watch?v=noi6aYsP7Go
class Content {
  int id = 0;
  String projectName = "";
  String client = "";
  String date = "";
  String comment = "";
  Map<int, Wall> squareMeters = {};
  List<CustomCameraImage> pictures = [];
  String material = "Q2";
  int statusActive = 1;
  double aiValue = 41.0;
  XFile? profileImage;
  String lastEdit = "";

  String street = "";
  String houseNumber = "";
  String zip = "";
  String city = "";

/*
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
      */

  static Map<String, dynamic> contentToMap(Content content) {
    Map<String, dynamic> map = {
      'id': content.id,
      'projectName': content.projectName,
      'client': content.client,
      'date': content.date,
      'material': content.material,
      'aiValue': content.aiValue,
      'comment': content.comment,
      'street': content.street,
      'houseNumber': content.houseNumber,
      'zip': content.zip,
      'city': content.city,
      'lastEdit': content.lastEdit
    };

    return map;
  }

/*
  static Future<List<XFile?>> getImagesOnly(int id) async {
    List<XFile?> listOfImages = [];
    await DataBase.getImages(id).then(
      (list) => {
        list.forEach((element) {
          listOfImages.add(XFile(element["image"].path));
        })
      },
    );
    return listOfImages;
  }
  */

  static Content mapToContent(Map<String, dynamic> map) {
    Content content = Content();
    content.id = map["id"];
    content.projectName = map["projectName"];
    content.client = map["client"];
    content.date = map["date"];
    content.pictures = [];
    content.material = map["material"];
    content.statusActive = map["statusActive"];
    content.comment = map["comment"];
    content.street = map["street"];
    content.houseNumber = map["houseNumber"];
    content.zip = map["zip"];
    content.city = map["city"];
    content.lastEdit = map["lastEdit"];
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
  String firstName = "";
  String lastName = "";
  int customerId = 0;
  String street = "";
  String houseNumber = "";
  String zip = "";
  String city = "";

  static const Map<String, dynamic> emptyUser = {
    'firstName': "",
    'lastName': "",
    'customerId': 0,
    'street': "",
    'houseNumber': "",
    'zip': "",
    'city': "",
  };

  static Map<String, dynamic> userToMap(User user) {
    Map<String, dynamic> content = {
      'firstName': user.firstName,
      'lastName': user.lastName,
      'customerId': user.customerId,
      'street': user.street,
      'houseNumber': user.houseNumber,
      'zip': user.zip,
      'city': user.city,
    };

    return content;
  }

  static User mapToUser(Map map) {
    User user = User();

    user.firstName = map["firstName"];
    user.lastName = map['lastName'];
    user.customerId = map['customerId'];
    user.street = map['street'];
    user.houseNumber = map['houseNumber'];
    user.zip = map['zip'];
    user.city = map['city'];

    return user;
  }
}

/// erzeugt eine MVP Wand, standardmäßig mit den Werten 0.0 * 0.0
class Wall {
  double width = 0.0;
  double height = 0.0;
}

class CustomCameraImage {
  int id;
  int projectId;
  XFile image;
  double aiValue;
  bool display;
  CustomCameraImage(
      {required this.id,
      this.projectId = 0,
      this.display = true,
      required this.image,
      this.aiValue = 0.0});
}
