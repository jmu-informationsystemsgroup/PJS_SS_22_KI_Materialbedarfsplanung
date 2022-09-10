import 'data_base_functions.dart';
import 'helper_objects.dart';

class ValueCalculator {
  static CalculatorOutcome officalOutcome = CalculatorOutcome();
  static List<int> wrongImages = [];

  /// erzeugt ein Objekt das alle Ergebnisse beinhaltet
  /// die Methode "getPrice" hängt von den totalSquareMeters ab und kann daher nicht eigenständig
  /// aufgerufen werden, daher diese Umgehung mit dem "Ergebnis-Objekt"
  static Future<CalculatorOutcome> getOutcomeObject(
      Content content, List<CustomCameraImage> images) async {
    resetOfficialOutcome();
    double aiOutcome = await getAIOutcome(content.id, images);
    double totalSquareMeters = await getSquareMeter(content.id);
    double totalPrice = getPrice(content.material, totalSquareMeters);
    double totalAiPrice = getAiPrice(content.material, aiOutcome);
    if (officalOutcome.exception) {
      officalOutcome.exceptionText = createExceptionText();
    }

    return officalOutcome;
  }

  static resetOfficialOutcome() {
    officalOutcome = CalculatorOutcome();
    wrongImages = [];
  }

  static String createExceptionText() {
    String wrongImagesString = wrongImages.toString();
    String sb = wrongImagesString.substring(1, wrongImagesString.length - 1);
    if (wrongImages.length == 1) {
      return "Das Bild mit der id $sb ist schadhaft, bitte löschen und neues Foto machen";
    } else {
      return "Die Bilder mit den ids $sb sind schadhaft, bitte löschen und neues Foto machen";
    }
  }

  static Future<double> getAIOutcome(
      int id, List<CustomCameraImage> images) async {
    double aiOutcome = 0.0;

    for (CustomCameraImage element in images) {
      if (element.aiValue == 0.0) {
        return 0.0;
      } else if (element.aiValue < 0.0) {
        wrongImages.add(element.id);
        officalOutcome.exception = true;
        continue;
      } else {
        aiOutcome = aiOutcome + element.aiValue;
      }
    }

    officalOutcome.aiOutcome = aiOutcome / 1000;
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

    officalOutcome.totalAiPrice = totalPrice;

    return totalPrice;
  }
}

class CalculatorOutcome {
  double aiOutcome;
  double totalSquareMeters;
  double totalPrice;
  double totalAiPrice;
  bool exception;
  String exceptionText;
  CalculatorOutcome(
      {this.aiOutcome = 0.0,
      this.totalSquareMeters = 0.0,
      this.totalPrice = 0.0,
      this.totalAiPrice = 0.0,
      this.exception = false,
      this.exceptionText = ""});
}
