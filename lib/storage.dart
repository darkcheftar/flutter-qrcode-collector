import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

class QRCodeStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/QRCodes.txt');
  }

  Future<List<String>> readqrcodes() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return (jsonDecode(contents) as List<dynamic>)
          .map((dynamic item) => item as String)
          .toList();
    } catch (e) {
      // If encountering an error, return 0
      return <String>[];
    }
  }

  Future<File> writeqrcodes(List<String> qrcodes) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(jsonEncode(qrcodes));
  }
}
