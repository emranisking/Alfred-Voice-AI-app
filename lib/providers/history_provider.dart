import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/history.dart';
import '../repositories/history_repository.dart';

class HistoryProvider with ChangeNotifier {
  final HistoryRepository repository;
  final AudioPlayer _player = AudioPlayer();

  List<History> _historyList = [];
  bool _isLoading = false;

  List<History> get historyList => _historyList;
  bool get isLoading => _isLoading;

  HistoryProvider({required this.repository});

  Future<void> fetchHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      _historyList = await repository.fetchHistory(); // fetch from local DB
    } catch (e) {
      print("Error fetching history: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addHistory(History history) async {
    try {
      final newHistory = await repository.addHistory(history); // save locally
      _historyList.insert(0, newHistory);
      notifyListeners();
      await playAudio(newHistory.mp3Path); // play from local file
    } catch (e) {
      print("Error adding history: $e");
    }
  }

  Future<void> playAudio(String path) async {
    try {
      await _player.setFilePath(path); // local file playback
      await _player.play();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}