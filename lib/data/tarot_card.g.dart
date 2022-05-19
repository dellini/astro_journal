// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tarot_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TarotCardAdapter extends TypeAdapter<TarotCard> {
  @override
  final int typeId = 0;

  @override
  TarotCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TarotCard(
      type: fields[0] as String,
      nameShort: fields[1] as String,
      name: fields[2] as String,
      value: fields[3] as String,
      valueInt: fields[4] as int,
      meaning: fields[5] as String,
      desc: fields[6] as String,
      imageUrl: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TarotCard obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.nameShort)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.value)
      ..writeByte(4)
      ..write(obj.valueInt)
      ..writeByte(5)
      ..write(obj.meaning)
      ..writeByte(6)
      ..write(obj.desc)
      ..writeByte(7)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TarotCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
