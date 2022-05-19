import 'package:astro_journal/data/tarot_card.dart';
import 'package:astro_journal/hive_types.dart';
import 'package:hive/hive.dart';

part 'tarot_card_dto.g.dart';

@HiveType(typeId: HiveTypes.tarotCardDto)
class TarotCardDTO {
  @HiveField(0)
  final DateTime createdAt;

  @HiveField(1)
  final TarotCard tarotCard;

  TarotCardDTO({
    required this.createdAt,
    required this.tarotCard,
  });
}

extension TarotCardExt on TarotCard {
  TarotCardDTO dtoWithCreatedTime() {
    return TarotCardDTO(createdAt: DateTime.now(), tarotCard: this);
  }
}
