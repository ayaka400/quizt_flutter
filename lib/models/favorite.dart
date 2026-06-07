import 'package:hive/hive.dart';

part 'favorite.g.dart';

@HiveType(typeId: 0)
class Favorite extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String question;

  @HiveField(2)
  final List<String> choices;

  @HiveField(3)
  final String answer;

  @HiveField(4)
  final String explanation;

  @HiveField(5)
  final String furtherStudy;

  @HiveField(6)
  final String topic;

  @HiveField(7)
  final String category;

  @HiveField(8)
  final DateTime savedAt;

  Favorite({
    required this.id,
    required this.question,
    required this.choices,
    required this.answer,
    required this.explanation,
    required this.furtherStudy,
    required this.topic,
    required this.category,
    required this.savedAt,
  });
}