import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> saveMp3Locally(String word, List<int> mp3Bytes) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$word-${DateTime.now().millisecondsSinceEpoch}.mp3');
  await file.writeAsBytes(mp3Bytes);
  return file.path;
}