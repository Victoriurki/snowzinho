import 'dart:io';

void main(List<String> args) async {
  final Directory dir;
  File file;
  final String fileName;

  dir = await Directory('lib/dir').create(recursive: true);
  fileName = '${dir.path}/file.dart';
  file = await File(fileName).create(recursive: true);
  file = await File(fileName)
      .writeAsString("void main(List<String> args){\nprint('Hello Word!');\n}");
}
