// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiaryNoteAdapter extends TypeAdapter<DiaryNote> {
  @override
  final int typeId = 2;

  @override
  DiaryNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiaryNote(
      date: fields[1] as DateTime,
      name: fields[2] as String,
      id: fields[0] as String?,
      situation: fields[3] as String?,
      thoughts: fields[4] as String?,
      emotion: fields[5] as String?,
      bodyReaction: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DiaryNote obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.situation)
      ..writeByte(4)
      ..write(obj.thoughts)
      ..writeByte(5)
      ..write(obj.emotion)
      ..writeByte(6)
      ..write(obj.bodyReaction);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiaryNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
