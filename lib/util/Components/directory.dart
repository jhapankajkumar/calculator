import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Future<String> localPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> localFile(fileName, extension) async {
  final path = await localPath();
  print('PATH $path');
  var file = File('$path/$fileName.$extension');
  return file;
}

Future<File> imagePath() async {
  final path = await localPath();
  var file = File('$path/chart');
  return file;
}

Future<Uint8List?> getImageData() async {
  var imageFilePath = await imagePath();
  if (imageFilePath.existsSync()) {
    try {
      Uint8List image = imageFilePath.readAsBytesSync();
      return image;
    } catch (e) {
      return null;
    }
  }
}
