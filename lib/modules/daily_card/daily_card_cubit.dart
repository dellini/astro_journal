import 'dart:async';

import 'package:astro_journal/data/export.dart';
import 'package:astro_journal/modules/history/hive_tarot_history_repository.dart';
import 'package:astro_journal/modules/daily_card/tarot_service.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

abstract class DailyCardState {}

class DailyCardInProgress extends DailyCardState {}

class DailyCardResult extends DailyCardState {
  final TarotCard dailyCard;

  DailyCardResult(this.dailyCard);
}

class DailyCardInitial extends DailyCardState {}

class DailyCardFailure extends DailyCardState {}

class DailyCardCubit extends Cubit<DailyCardState> {
  final TarotHistoryRepositoryHive historyRepository;
  final FirebaseStorage firebaseStorage;

  late final BehaviorSubject<List<TarotCardDTO>> _history = BehaviorSubject();

  Stream<List<TarotCardDTO>> get history => _history.stream;

  DailyCardCubit({
    required this.historyRepository,
    required this.firebaseStorage,
  }) : super(DailyCardInitial()) {
    historyRepository.tarotCardHistory.then<void>(_history.add);
  }

  Future<void> getRandomCard() async {
    if (state is DailyCardInProgress) {
      return;
    }
    emit(DailyCardInProgress());

    final card = await getRandomTarotCard();

    if (card != null) {
      final imageUrl = await getTarotImage(
        storage: FirebaseStorage.instance,
        tarotImageKey: card.nameShort,
      );

      if (imageUrl.isNotEmpty) {
        final cardWithImage = card.copyWith(imageUrl: imageUrl);

        await historyRepository.addCardToHistory(cardWithImage);
        _history.sink.add(await historyRepository.tarotCardHistory);
        setCard(cardWithImage);
      } else {
        emit(DailyCardFailure());
      }
    } else {
      emit(DailyCardFailure());
    }
  }

  void setCard(TarotCard card) {
    emit(DailyCardResult(card));
  }

  void resetCard() {
    emit(DailyCardInitial());
  }

  Future<void> clearHistory() async {
    await historyRepository
        .deleteAllCards(_history.value.map((e) => e.tarotCard));
  }

  Future<void> fixCardsUrls() async {
    final history = await historyRepository.tarotCardHistory;
    for (final card in history) {
      if (card.tarotCard.imageUrl.startsWith('http')) {
        await historyRepository.updateCard(
          card.tarotCard.copyWith(
            imageUrl:
                'gs://${firebaseStorage.bucket}/tarot/${card.tarotCard.nameShort}.jpg',
          ),
        );
      }
    }
  }

  void dispose() {
    _history.close();
  }
}
