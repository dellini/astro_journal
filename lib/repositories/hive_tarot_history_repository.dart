import 'package:astro_journal/data/tarot_card.dart';
import 'package:astro_journal/data/tarot_card_dto.dart';
import 'package:hive/hive.dart';

class HiveTarotHistoryRepository {
  final Box<TarotCardDTO> box;

  HiveTarotHistoryRepository(this.box);
}
