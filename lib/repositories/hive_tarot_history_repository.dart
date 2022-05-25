import 'package:astro_journal/data/tarot_card.dart';
import 'package:astro_journal/data/tarot_card_dto.dart';
import 'package:astro_journal/date_extensions.dart';
import 'package:hive/hive.dart';

class HiveTarotHistoryRepository {
  final Box<TarotCardDTO> box;

  List<TarotCardDTO> get tarotCardHistory {
    final finishDate = DateTime.now();
    final startDate = finishDate.subtract(const Duration(days: 7)).date;
    final periodHistory = box.values
        .where((e) =>
            e.createdAt.isBefore(finishDate) && e.createdAt.isAfter(startDate))
        .toList()
      ..sort(
        (a, b) => a.createdAt.compareTo(b.createdAt),
      );
    return periodHistory;
  }

  HiveTarotHistoryRepository(this.box);

  Future<void> addCartToHistory(TarotCard card) async {
    await box.add(card.dtoWithCreatedTime());
  }
}
