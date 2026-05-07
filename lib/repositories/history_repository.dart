import '../models/history.dart';

abstract class HistoryRepository {
  Future<List<History>> fetchHistory();
  Future<History> addHistory(History history);
}