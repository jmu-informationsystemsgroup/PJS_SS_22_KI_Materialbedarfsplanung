import 'data_base_functions.dart';
import 'helper_objects.dart';

class ValueCalculator {
  static CalculatorOutcome officalOutcome = CalculatorOutcome();
  static List<int> wrongImages = [];
  static bool imagesNeedToBeSynced = false;

  /// erzeugt ein Antwort-Objekt das alle Ergebnisse beinhaltet
  /// die Methode "getPrice" hängt von den totalSquareMeters ab und kann daher nicht eigenständig
  /// aufgerufen werden, daher diese Umgehung mit dem "Ergebnis-Objekt"
  /// außerdem kann das Objekt genutzt werden um Exceptions, sowie Exceptionnachrichten nachzuliefern
  static CalculatorOutcome calculate(
      {required Content content,
      required List<CustomCameraImage> images,
      required List<Wall> walls}) {
    resetOfficialOutcome();
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$walls");
    List<double> outcomes = getAIOutcome(content.id, images);
    double aiOutcome = outcomes[0];
    double aiEdgeOutcome = outcomes[1];
    double totalSquareMeters = getSquareMeters(walls);
    double manualMaterial = getManualMaterial(totalSquareMeters);
    double manualEdgeLength = getManualEdges(totalSquareMeters);

    if (!imagesNeedToBeSynced) {
      officalOutcome.material = aiOutcome + manualMaterial;
      officalOutcome.edges = aiEdgeOutcome + manualEdgeLength;
    }

    //  getManualPrice(content.material, totalSquareMeters);
    getAiPrice(content.material);
    getEdgePrice();
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
      return "Das Bild mit der id $sb ist schadhaft. Es wurde daher nicht mit in die Berechnung aufgenommen. " +
          "Bitte löschen und neues Foto machen";
    } else {
      return "Die Bilder mit den ids $sb sind schadhaft. Sie wurden daher nicht mit in die Berechnung aufgenommen. " +
          "Bitte löschen und neue Fotos machen";
    }
  }

  /// zählt die KI-Ergebnisse aller Bilder zu einem Projekt zusammen. Wenn zu einem Bild noch kein Wert
  /// ermittelt wurde (= 0.0), wird der Rechenprozess abgebrochen und der User wird gebeten eine
  /// Internetverbindung herzustellen um die fehlenden Daten nachzualden.
  /// Wenn zu einem Bild ein ungültiger KI Wert ermittelt wurde (< 0) wird das Bild aus der Berechnung
  /// herausgenommen und der Nutzer wird aufgfordert, dieses nochmal nachzufotografieren. Der Rechenprozess
  /// kann aber trotzdem weiter fortgesetzt werden
  static List<double> getAIOutcome(int id, List<CustomCameraImage> images) {
    double aiOutcome = 0.0;
    double aiEdgeOutcome = 0.0;

    for (CustomCameraImage element in images) {
      if (element.aiValue == 0.0 || element.aiValueEdges == 0.0) {
        imagesNeedToBeSynced = true;
        return [0.0, 0.0];
      } else if (element.aiValue < 0.0 || element.aiValueEdges < 0.0) {
        wrongImages.add(element.id);
        officalOutcome.exception = true;
        continue;
      } else {
        aiOutcome = aiOutcome + element.aiValue;
        aiEdgeOutcome = aiEdgeOutcome + element.aiValueEdges;
      }
    }
    imagesNeedToBeSynced = false;

    return [aiOutcome / 1000, aiEdgeOutcome / 1000];
  }

  static double getSquareMeters(List<Wall> walls) {
    double totalSquareMeters = 0.0;

    for (Wall element in walls) {
      double actualSquareMeters = element.width * element.height;

      totalSquareMeters = totalSquareMeters + actualSquareMeters;
    }

    return totalSquareMeters;
  }

  static double getManualMaterial(double totalSquareMeters) {
    return totalSquareMeters * 0.5223880597;
  }

  static double getManualEdges(double totalSquareMeters) {
    return totalSquareMeters * 2.26;
  }

  static getManualPrice(String material, double totalSquareMeters) {
    double totalPrice = 0.0;
    Map<String, double> valueInterpreter = {"Q2": 0.7, "Q3": 2, "Q4": 3.5};
    totalPrice = totalSquareMeters * valueInterpreter[material]!;

    officalOutcome.priceMaterial += totalPrice;
  }

  static getAiPrice(String material) {
    double totalPrice = 0.0;
    Map<String, double> quality = {"Q2": 1, "Q3": 2.85, "Q4": 5};
    totalPrice = (officalOutcome.material * 1.34 * quality[material]!);

    officalOutcome.priceMaterial += totalPrice;
  }

  static getEdgePrice() {
    officalOutcome.priceEdges += (officalOutcome.edges * 0.26);
  }
}

class CalculatorOutcome {
  double material;
  double priceMaterial;
  double edges;
  double priceEdges;
  bool exception;
  String exceptionText;
  CalculatorOutcome(
      {this.material = 0.0,
      this.edges = 0.0,
      this.priceEdges = 0.0,
      this.priceMaterial = 0.0,
      this.exception = false,
      this.exceptionText = ""});
}
