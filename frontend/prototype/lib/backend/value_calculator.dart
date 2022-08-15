import 'data_base_functions.dart';
import 'helper_objects.dart';

class ValueCalculator {
  /// erzeugt ein Objekt das alle Ergebnisse beinhaltet
  /// die Methode "getPrice" hängt von den totalSquareMeters ab und kann daher nicht eigenständig
  /// aufgerufen werden, daher diese Umgehung mit dem "Ergebnis-Objekt"
  static Future<Map<String, dynamic>> getOutcomeObject(
      Map<String, dynamic> content) async {
    double aiOutcome = await getAIOutcome(content["id"]);
    double totalSquareMeters = await getSquareMeter(content["id"]);
    double totalPrice = getPrice(content["material"], totalSquareMeters);

    return {
      "aiOutcome": aiOutcome,
      "totalSquareMeters": totalSquareMeters,
      "totalPrice": totalPrice
    };
  }

  static Future<double> getAIOutcome(int id) async {
    double aiOutcome = 0.0;
    List images = await DataBase.getImages(id);

    for (var element in images) {
      aiOutcome = aiOutcome + element["aiValue"];
    }
    return aiOutcome;
  }

  static Future<double> getSquareMeter(int id) async {
    double totalSquareMeters = 0.0;
    var walls = await DataBase.getWalls(id);

    walls.forEach((element) {
      double width = 0.0;
      double height = 0.0;
      try {
        width = element["width"];
        height = element["height"];
      } catch (e) {}

      double actualSquareMeters = width * height;

      totalSquareMeters = totalSquareMeters + actualSquareMeters;
    });

    return totalSquareMeters;
  }

  static double getPrice(String material, double totalSquareMeters) {
    double totalPrice = 0.0;
    Map<String, double> valueInterpreter = {"Q2": 0.7, "Q3": 2, "Q4": 3.5};
    totalPrice = totalSquareMeters * valueInterpreter[material]!;

    return totalPrice;
  }
}
