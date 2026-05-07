import 'package:flutter/services.dart' show rootBundle;

Future<String?> loadVoiceId() async {
  try {
    final content = await rootBundle.loadString('assets/voice/voice_id.txt');
    final voiceId = content.trim();
    print("✅ Loaded Voice ID: $voiceId");
    return voiceId.isNotEmpty ? voiceId : null;
  } catch (e) {
    print("❌ Failed to load Voice ID: $e");
    return null;
  }
}