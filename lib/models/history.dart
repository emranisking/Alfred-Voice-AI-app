import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'history.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class History extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final String mp3Path;

  History({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.mp3Path,
  });

  factory History.fromJson(Map<String, dynamic> json) => _$HistoryFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}