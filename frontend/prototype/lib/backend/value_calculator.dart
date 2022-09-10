import 'data_base_functions.dart';
import 'helper_objects.dart';

class ValueCalculator {
  /// erzeugt ein Objekt das alle Ergebnisse beinhaltet
  /// die Methode "getPrice" hängt von den totalSquareMeters ab und kann daher nicht eigenständig
  /// aufgerufen werden, daher diese Umgehung mit dem "Ergebnis-Objekt"
  static Future<CalculatorOutcome> getOutcomeObject(
      Content content, List<CustomCameraImage> images) async {
    double aiOutcome = await getAIOutcome(content.id, images);
    double totalSquareMeters = await getSquareMeter(content.id);
    double totalPrice = getPrice(content.material, totalSquareMeters);
    double totalAiPrice = getAiPrice(content.material, aiOutcome);

    return CalculatorOutcome(aiOutcome: aiOutcome, totalAiPrice: totalAiPrice);
  }

  static Future<double> getAIOutcome(
      int id, List<CustomCameraImage> images) async {
    double aiOutcome = 0.0;

    for (CustomCameraImage element in images) {
      if (element.aiValue == -1.0) {
        return -1.0;
      } else {
        aiOutcome = aiOutcome + element.aiValue;
      }
    }
    return aiOutcome / 1000;
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
    totalPrice = (aiOutcome * valueInterpreter[material]!);

    return totalPrice;
  }
}

class CalculatorOutcome {
  double aiOutcome;
  double totalSquareMeters;
  double totalPrice;
  double totalAiPrice;
  CalculatorOutcome(
      {this.aiOutcome = -48.0,
      this.totalSquareMeters = 0.0,
      this.totalPrice = 0.0,
      this.totalAiPrice = 0.0});
}
