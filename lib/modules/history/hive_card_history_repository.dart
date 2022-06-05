import 'package:astro_journal/data/export.dart';
import 'package:astro_journal/date_extensions.dart';
import 'package:hive/hive.dart';

class TarotHistoryRepositoryHive {
  static const boxName = 'tarotHistoryBoxName';

  final Box<TarotCardDTO> box;

  Future<List<TarotCardDTO>> get tarotCardHistory async {
    final finishDate = DateTime.now().add(const Duration(days: 1)).date;
    final startDate = finishDate.subtract(const Duration(days: 7)).date;
    final markForDeleting = <TarotCard>[];
    final periodHistory = box.values
        .map((e) {
          final isInPeriod = e.createdAt.isBefore(finishDate) &&
              e.createdAt.isAfter(startDate);

          if (isInPeriod) {
            return e;
          } else {
            markForDeleting.add(e.tarotCard);
            return null;
          }
        })
        .whereType<TarotCardDTO>()
        .toList();
    await deleteAllCards(markForDeleting);
    periodHistory.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return periodHistory;
  }

  TarotHistoryRepositoryHive(this.box);

  Future<void> addCardToHistory(TarotCard card) async {
    await box.put(card.id, card.dtoWithCreatedTime());
  }

  Future<void> updateCard(TarotCard card) async {
    final existing = box.get(card.id);
    if (existing != null) {
      await box.put(
        card.id,
        TarotCardDTO(
          createdAt: existing.createdAt,
          tarotCard: card,
        ),
      );
    }
  }

  Future<void> deleteCard(TarotCard card) async {
    await box.delete(card.id);
  }

  Future<void> deleteAllCards(Iterable<TarotCard> cards) async {
    await box.deleteAll(cards.map<String>((e) => e.id));
  }
}
