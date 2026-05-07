import 'package:flutter/services.dart' show rootBundle;

Future<List<String>> loadApiKeys() async {
  try {
    final content = await rootBundle.loadString('assets/dump/dump.txt');
    final keys = content
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    print("✅ Loaded API keys: $keys");
    return keys;
  } catch (e) {
    print("❌ Failed to load API keys: $e");
    return [];
  }
}