import 'dart:io';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

/// toilett: http://ptsv2.com/t/gkeu3-1662648870 Body can't be larger than 1,500 bytes

class AI_Server {
  static uploadFile(XFile file, int id) async {
    var client = http.Client();
    // var bitlist = await uploadFIle.readAsBytes();
    try {
      /*
      print(">>>>>>>>>>>>>>>>>>>>>>>>>i was activated");

      var response2 = await client.post(
          Uri.http('ptsv2.com', '/t/gkeu3-1662648870/post'),
          body: "test1");

      var url = Uri.http('ptsv2.com', '/t/gkeu3-1662648870/post');
      var response = await http.post(url, body: "test2");
*/
      http.MultipartRequest request = http.MultipartRequest(
        "POST",
        Uri.parse("http://ptsv2.com/t/gkeu3-1662648870/post"),
      );
/*
      request.fields['title'] = "test";
      request.headers['Authorization'] = "";
      */

// funktioneirt eventuell nicht, da pfad noch nicht vorhanden
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('image', file.path);
      request.files.add(multipartFile);

      http.StreamedResponse response = await request.send();

      String aiOutcome = response.statusCode.toString();

      // double aiOutcomeDouble = double.parse(aiOutcome);

      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${aiOutcome}");
    } finally {
      client.close();
    }
  }
}
