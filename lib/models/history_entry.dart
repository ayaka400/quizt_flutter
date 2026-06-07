import 'package:hive/hive.dart';

part 'history_entry.g.dart';

@HiveType(typeId: 1)
class HistoryEntry extends HiveObject {
  @HiveField(0)
  final bool isCorrect;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final String topic;

  @HiveField(3)
  final DateTime answeredAt;

  @HiveField(4)
  final String question;

  @HiveField(5)
  final List<String> choices;

  @HiveField(6)
  final String answer;

  HistoryEntry({
    required this.isCorrect,
    required this.category,
    required this.topic,
    required this.answeredAt,
    required this.question,
    required this.choices,
    required this.answer,
  });
}