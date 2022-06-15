import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

import 'package:prototype/localDrive/content.dart';

import '../newProject/saveTest.dart';

class FileUtils {
  static Future<String?> get getFilePath async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    Directory? tempDir = await DownloadsPathProvider.downloadsDirectory;
    String? tempPath = tempDir?.path;
    return tempPath;
  }

  static Future<File> get getFile async {
    final path = await getFilePath;
    return File('$path/myfile.txt');
  }

  static Future<File> get getJsonFile async {
    final path = await getFilePath;
    return File('$path/myotherfile.json');
  }

  static Future<File> saveToFile(String data) async {
    final file = await getFile;
    return file.writeAsString(data);
  }

  static Future<String> readFromFile() async {
    try {
      final file = await getFile;
      String fileContents = await file.readAsString();
      return fileContents;
    } catch (e) {
      return "File konnte nicht gefunden werden";
    }
  }

  static Future<Map<String, dynamic>> readJsonFile() async {
    String fileContents = '';
    try {
      final file = await getJsonFile;
      fileContents = await file.readAsString();
    } catch (e) {
      print("File konnte nicht gefunden werden");
    }
    return json.decode(fileContents);
  }

  static Future<Content> writeJsonFile(data) async {
    final Content content = data;

    File file = await getJsonFile;
    await file.writeAsString(jsonEncode(content));

    return data;
  }
/*
  readContent() async {
    content = Content.fromJson(await readJsonFile());
  }
  */
}
