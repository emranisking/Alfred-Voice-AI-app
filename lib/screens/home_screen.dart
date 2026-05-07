import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../models/history.dart';
import '../providers/history_provider.dart';
import '../utils/api_key_loader.dart';
import '../utils/voice_id_loader.dart'; // NEW

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _latestMp3Path;

  void _showSiriLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [Colors.blueAccent, Colors.black],
              center: Alignment.center,
              radius: 0.8,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              strokeWidth: 6,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> _saveMp3Locally(String word, Uint8List bytes) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$word-${DateTime.now().millisecondsSinceEpoch}.mp3');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  Future<Uint8List?> _synthesizeVoice(String text, String voiceId) async {
    final apiKeys = await loadApiKeys();

    for (final key in apiKeys) {
      try {
        print("🔑 Trying key: $key");
        final response = await http.post(
          Uri.parse('https://api.elevenlabs.io/v1/text-to-speech/$voiceId'),
          headers: {
            'xi-api-key': key,
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'text': text,
            'model_id': 'eleven_monolingual_v1',
            'voice_settings': {
              'stability': 0.5,
              'similarity_boost': 0.5,
            }
          }),
        );

        print("📡 Response code: ${response.statusCode}");
        print("📄 Response body: ${response.body}");

        if (response.statusCode == 200) {
          return response.bodyBytes;
        }
      } catch (e) {
        print("❌ Error with key $key: $e");
        continue;
      }
    }

    return null;
  }

  void _generateVoice() async {
    final provider = context.read<HistoryProvider>();
    final word = _controller.text.trim();
    if (word.isEmpty) return;

    _showSiriLoading();

    try {
      final voiceId = await loadVoiceId();
      if (voiceId == null) throw Exception("Voice ID missing");

      final mp3Bytes = await _synthesizeVoice(word, voiceId);
      if (mp3Bytes != null) {
        final filePath = await _saveMp3Locally(word, mp3Bytes);
        final history = History(
          id: 0,
          message: word,
          timestamp: DateTime.now(),
          mp3Path: filePath,
        );
        await provider.addHistory(history);
        setState(() => _latestMp3Path = filePath);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("All API keys failed or ElevenLabs unreachable.")),
        );
      }
    } catch (e) {
      print("Error generating voice: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Voice generation failed.")),
      );
    }

    Navigator.pop(context);
  }

  void _playVoice() async {
    if (_latestMp3Path != null) {
      await _audioPlayer.play(DeviceFileSource(_latestMp3Path!));
    }
  }

  void _pauseVoice() async {
    await _audioPlayer.pause();
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<HistoryProvider>();

    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF0A0E21),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blueAccent),
                child: Text('Alfred AI', style: TextStyle(fontSize: 24, color: Colors.white)),
              ),
              ListTile(
                leading: Image.asset('assets/icon/history.png', width: 24, height: 24),
                title: const Text('History', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  provider.fetchHistory();
                  Navigator.pushNamed(context, '/history');
                },
              ),
              ListTile(
                leading: Image.asset('assets/icon/coding.png', width: 24, height: 24),
                title: const Text('Developer Info', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/developer');
                },
              ),
              ListTile(
                leading: Image.asset('assets/icon/donate.png', width: 24, height: 24),
                title: const Text('Donate', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/donate');
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Image.asset('assets/icon/menu.png', width: 24, height: 24, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text("Alfred AI Voice Butler"),
        actions: [
          IconButton(
            icon: Image.asset('assets/icon/history.png', width: 24, height: 24, color: Colors.white),
            onPressed: () {
              provider.fetchHistory();
              Navigator.pushNamed(context, '/history');
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0E21), Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              "Speak your inspiration",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Type your thoughts here...",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _generateVoice,
              icon: Image.asset('assets/icon/artificial-intelligence.png', width: 24, height: 24),
              label: const Text("Generate Voice"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            if (_latestMp3Path != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _playVoice,
                    icon: Image.asset('assets/icon/play-button-arrowhead.png', width: 24, height: 24),
                    label: const Text("Play"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,

                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _pauseVoice,
                    icon: Image.asset('assets/icon/pause.png', width: 24, height: 24),
                    label: const Text("Pause"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}