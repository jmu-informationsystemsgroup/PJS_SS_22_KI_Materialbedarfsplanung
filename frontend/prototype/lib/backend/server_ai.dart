import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/backend/helper_objects.dart';

/// toilett: http://ptsv2.com/t/gkeu3-1662648870 Body can't be larger than 1,500 bytes

class ServerAI {
  /// sendet eine Liste an Bildern an den Server auf dem sich KI befindet. Der Wert den die KI
  /// pro Bild zurückgibt, wird auf der image Datentabelle an der passenden Stelle anhand der
  /// projectId und Bild id eingetragen.
  static Future<List<CustomCameraImage>> getAiValuesFromServer(
      List<CustomCameraImage> images,
      Function(int) stateUpdate,
      Function() connectionHandler) async {
    double currentState = 0.0;
    double finishedState = images.length.toDouble();
    double step = 100.0 / finishedState;
    for (var element in images) {
      XFile file = element.image;
      int projectId = element.projectId;
      int id = element.id;

      // var bitlist = await uploadFIle.readAsBytes();

/*
      var response2 = await client
          .post(Uri.http('ptsv2.com', '/t/gkeu3-1662648870'), body: "test1");

      var url = Uri.http('weller.well-city.de:5000', '/predict');
      var response = await http.post(url, body: "test2");
      await http.ByteStream

      var url3 = Uri.parse("http://weller.well-city.de:5000/predict");
      var response3 = await http.post(url, body: "test3");

*/
      // Final Post
      http.MultipartRequest request = http.MultipartRequest(
        "POST",
        Uri.parse("http://weller.well-city.de:5000/predict"),
      );
      request.fields["title"] = "test";
      request.headers["Content-Type"] = "multiparts/form-data";
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('file', file.path);
      request.files.add(multipartFile);

      try {
        http.StreamedResponse response =
            await request.send().timeout(const Duration(seconds: 8));
        String statusCode = response.statusCode.toString();
        Uint8List aiOutcome = await response.stream.toBytes();
        String aiOutcomeString = String.fromCharCodes(aiOutcome);
        // double aiOutcomeDouble = double.parse(aiOutcome);

        double aiValue = double.parse(aiOutcomeString);
        await DataBase.updateImagesAiValue(aiValue, id, projectId);
        print("Server Status $statusCode: ai-outcome: $aiValue");
        element.aiValue = aiValue;
        currentState = currentState + step;
        stateUpdate(currentState.toInt());
      } catch (e) {
        connectionHandler();
      }
    }
    return images;
  }
}
