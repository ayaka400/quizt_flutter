// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryEntryAdapter extends TypeAdapter<HistoryEntry> {
  @override
  final int typeId = 1;

  @override
  HistoryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryEntry(
      isCorrect: fields[0] as bool,
      category: fields[1] as String,
      topic: fields[2] as String,
      answeredAt: fields[3] as DateTime,
      question: fields[4] as String,
      choices: (fields[5] as List).cast<String>(),
      answer: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryEntry obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.isCorrect)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.topic)
      ..writeByte(3)
      ..write(obj.answeredAt)
      ..writeByte(4)
      ..write(obj.question)
      ..writeByte(5)
      ..write(obj.choices)
      ..writeByte(6)
      ..write(obj.answer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
