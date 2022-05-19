// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tarot_card_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TarotCardDTOAdapter extends TypeAdapter<TarotCardDTO> {
  @override
  final int typeId = 1;

  @override
  TarotCardDTO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TarotCardDTO(
      createdAt: fields[0] as DateTime,
      tarotCard: fields[1] as TarotCard,
    );
  }

  @override
  void write(BinaryWriter writer, TarotCardDTO obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.createdAt)
      ..writeByte(1)
      ..write(obj.tarotCard);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TarotCardDTOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
