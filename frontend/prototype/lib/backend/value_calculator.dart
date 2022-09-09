import 'data_base_functions.dart';
import 'helper_objects.dart';

class ValueCalculator {
  double aiOutcome;
  double totalSquareMeters;
  double totalPrice;
  double totalAiPrice;
  ValueCalculator(
      {this.aiOutcome = -1.0,
      this.totalSquareMeters = 0.0,
      this.totalPrice = 0.0,
      this.totalAiPrice = 0.0});

  /// erzeugt ein Objekt das alle Ergebnisse beinhaltet
  /// die Methode "getPrice" hängt von den totalSquareMeters ab und kann daher nicht eigenständig
  /// aufgerufen werden, daher diese Umgehung mit dem "Ergebnis-Objekt"
  static Future<ValueCalculator> getOutcomeObject(Content content) async {
    double aiOutcome = await getAIOutcome(content.id);
    double totalSquareMeters = await getSquareMeter(content.id);
    double totalPrice = getPrice(content.material, totalSquareMeters);
    double totalAiPrice = getAiPrice(content.material, aiOutcome);

    return ValueCalculator(aiOutcome: aiOutcome, totalAiPrice: totalAiPrice);
  }

  static Future<double> getAIOutcome(int id) async {
    double aiOutcome = 0.0;
    List<CustomCameraImage> images = await DataBase.getImages(id);

    for (CustomCameraImage element in images) {
      if (element.aiValue == -1.0) {
        return -1.0;
      } else {
        aiOutcome = aiOutcome + element.aiValue;
      }
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

  static double getAiPrice(String material, double aiOutcome) {
    double totalPrice = 0.0;
    Map<String, double> valueInterpreter = {"Q2": 0.7, "Q3": 2, "Q4": 3.5};
    totalPrice = aiOutcome * valueInterpreter[material]!;

    return totalPrice;
  }
}
