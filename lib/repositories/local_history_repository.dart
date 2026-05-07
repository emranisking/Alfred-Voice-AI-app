import 'package:hive/hive.dart';
import '../models/history.dart';
import 'history_repository.dart';

class LocalHistoryRepository extends HistoryRepository {
  final Box<History> _box = Hive.box<History>('history');



  @override
  Future<List<History>> fetchHistory() async {
    return _box.values.toList().reversed.toList();
  }

  @override
  Future<History> addHistory(History history) async {
    await _box.add(history);
    return history;
  }


}